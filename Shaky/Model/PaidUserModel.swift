//
//  PurchaseModel.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 9.11.2023.
//

import Foundation
import StoreKit

// Decision: First init Purchase model then access UserModel.shared properties
class PaidUserModel : ObservableObject {
    static let shared = PaidUserModel()
    
    private let productIds = ["adsfree"]
    @Published var productsAvailable : [Product] = []
    @Published var userIsPremium = false
    
    var updateListenerTask: Task<Void, Error>? = nil
    init() {
        getPremiumStatus()
        updateListenerTask = listenForTransactions()
        Task{
            await fetchAvailableProducts()
            await updateUserPurchases()
        }
    }
    
    @MainActor
    func fetchAvailableProducts() async{
        do{
            print("fetchAvailableProducts() fetching products")
            let fetch = try await Product.products(for: productIds)
            // Sort Products by price
            self.productsAvailable = fetch.sorted{ $0.price < $1.price }
        }
        catch{}
    }
    
    
    //denit transaction listener on exit or app close
    deinit {
        updateListenerTask?.cancel()
    }
    

    //listen for transactions - start this early in the app
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //iterate through any transactions that don't come from a direct call to 'purchase()'
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    //the transaction is verified, deliver the content to the user
                    await self.updateUserPurchases()
                    
                    //Always finish a transaction
                    await transaction.finish()
                } catch {
                    //storekit has a transaction that fails verification, don't delvier content to the user
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //check if JWS passes the StoreKit verification
        switch result {
        case .unverified:
            //failed verificaiton
            throw StoreError.failedVerification
        case .verified(let signedType):
            //the result is verified, return the unwrapped value
            return signedType
        }
    }
    
    
    
    @MainActor
    func updateUserPurchases() async {
        print("updateUserPurchases()")
        
        var purchasedProducts: [Product] = []
                
        //iterate through all the user's purchased products
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if let product = productsAvailable.first(where: { $0.id == transaction.productID}) {
                    purchasedProducts.append(product)
                    // TODO: mark user as premium
                    updatePremiumStatus(status: true)
                }
            } catch {
                print("Transaction failed verification")
            }
        }
        
        if (purchasedProducts == []){
            updatePremiumStatus(status: false)
        }
    }
    
    
    func purchase(product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            await updateUserPurchases()
            await transaction.finish()
            
            logEvent(eventName: "purchased_succesfully", params: [
                "product" : product.id as NSObject,
                "price" : product.displayPrice as NSObject
            ])
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
        
    }
    
}

public enum StoreError: Error {
    case failedVerification
}



extension PaidUserModel{
    
    private func updatePremiumStatus(status : Bool){
        self.userIsPremium = status
        UserDefaults.standard.set(status, forKey: "userIsPremium")
    }
    
    private func getPremiumStatus() {
        self.userIsPremium = UserDefaults.standard.bool(forKey: "userIsPremium")
    }
    
}
