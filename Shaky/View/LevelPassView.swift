//
//  LevelPassView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 8.11.2023.
//

import SwiftUI
import GoogleMobileAds

struct LevelPassView: View {
    @State private var interstitial: GADInterstitialAd?
    let completion : completionType
    let completedLevel : Int
    @State var paidUser : Bool = PaidUserModel.shared.userIsPremium
    var title : String { return completion == .success ? "High Five 👏" : "Oops... 🫤"}
    var subText : String { return completion == .success ? "What a success!" : "Wanna try again?"}
    var actionText : String { return completion == .success ? "Continue 👉" : "Try Again 🔄"}
    
    @State var showLevel = false
        
    var body: some View {
        
        if showLevel{
            
            if completedLevel == gameLevels.count {
                GameLevelView(gameLevel: gameLevels[completedLevel-1])
            } else{
                GameLevelView(gameLevel: gameLevels[completedLevel])

            }
            
        } else{
            
            VStack{
                fullWidthText(name: title)
                fullWidthText(name: subText)
                
                Spacer()
                
                //MARK: ADVERTISEMENTS
                Group{
                    if !paidUser {
                        Text("ADVERTISEMENT-HERE")
                        
                        Spacer()
                        fullWidthTextButton(name: "Skip Advertisements"){
                            print("skip ads clicked")
                            Task {
                                let p = PaidUserModel.shared.productsAvailable.first
                                if let product = p {
                                    _ = try await PaidUserModel.shared.purchase(product: product)
                                }
                            }
                        }
                    } else {
                        fullWidthTextButton(name: actionText){
                            print("continue")
                            triggerClickHaptic()
                            showLevel = true
                        }
                        
                        if completion == .success{
                            Text("To Level \(completedLevel + 1)")
                                .font(.system(size: 20))
                        }
                    }
                }
                .onAppear{
                    GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest(), completionHandler: { [self] ad, error in
                        if let error = error {
                            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                            return
                        }
                        print("ad has been fetched")
                        interstitial = ad
                        // Solve with UIKit
                        interstitial?.present(fromRootViewController: UIHostingController(rootView: self))
                    })
                }
                
            }
            .padding(.all)
            .onAppear{
                Music.shared.playMainMusic(action: .pause)
                Music.shared.playLevelTransitSound(completionType: completion)
            }
            .onDisappear(perform: {
                Music.shared.playMainMusic(action: .resume)
            })
        }
    }
}


#Preview {
    
    LevelPassView(completion: .success,
                  completedLevel: 1)
}


extension LevelPassView{
    enum completionType {
        case success
        case fail
    }
    
}

