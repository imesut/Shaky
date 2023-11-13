//
//  LevelPassView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 8.11.2023.
//

import SwiftUI
import GoogleMobileAds
import StoreKit

struct LevelPassView: View {
    // InContexts / Privates / Message Parameters
    private var title : String { return completion == .success ? "High Five" : "Oops..."}
    private var subText : String { return completion == .success ? "What a success!" : "Wanna try again?"}
    private var actionText : String { return completion == .success ? "Continue 👉" : "Try Again 🔄"}
    private let successEmojis = ["👏", "🚀", "😎", "🤘", "🪨", "👏"]
    private let failEmojis = ["🥺", "🤦🏻‍♂️", "🙊", "🙈", "🙄", "🤯", "🫤"]
    // Initializations
    let completion : completionType
    let playedLevel : Int
    var theLevelToContinue : Int {
        return completion == .success ? playedLevel + 1 : playedLevel
    }
    var productLoaded : Product? { return PaidUserModel.shared.productsAvailable.first }

    // States
    @State var continueToTheGame = false
    @State private var selectedEmoji : String?
    @State var paidUser : Bool = PaidUserModel.shared.userIsPremium
    @State var showAd : Bool = false
    @State private var interstitial: GADInterstitialAd?
    // Animation States
    @State var showActionButton = false
    @State var scaleOfSkipAdButton = 1.00
        
    var body: some View {
        
        if continueToTheGame{
            GameLevelView(gameLevel: getLevelData(level: theLevelToContinue))
            
        } else{
            
            VStack{
                //MARK: - Title
                Group{
                    fullWidthText(name: title)
                    fullWidthText(name: subText)
                }
                
                Spacer()
                
                // Emoji
                fullWidthText(name: selectedEmoji ?? "").padding(.horizontal, 40)
                    .onAppear{
                        if completion == .success{ selectedEmoji = successEmojis.randomElement()! }
                        else{ selectedEmoji = failEmojis.randomElement()! }
                    }
                
                Spacer()
                
                //MARK: -  ADVERTISEMENTS
                //TODO: Check Advertisement Logic in detail to be sure. After submitting to the App Store.
                Group{
                    if !paidUser && productLoaded != nil {
                        fullWidthTextButton(name: "Skip Advertisements"){
                            print("skip ads clicked")
                            Task {
                                if productLoaded != nil {
                                    _ = try await PaidUserModel.shared.purchase(product: productLoaded!)
                                }
                            }
                        }.scaleEffect(scaleOfSkipAdButton)
                    }
                }
                .onAppear{
                    showAd = true
                    print("ADDEBUG: on LevelPassView, ad Display status: ", showAd)
                    withAnimation(.easeInOut(duration: 0.750).repeatForever()){
                        scaleOfSkipAdButton = 1.05
                    }
                }
                .presentInterstitialAd(isPresented: $showAd, adUnitId: "ca-app-pub-3654508956041872/4945256256")
                //MARK: - End of Ads
                
                
                if showActionButton{
                    fullWidthTextButton(name: actionText){
                        Music.shared.playMainMusic(action: .resume)
//                        print("continue")
                        triggerClickHaptic()
                        continueToTheGame = true
                    }
                    
                    if playedLevel != theLevelToContinue {
                        Text("To Level \(theLevelToContinue)")
                            .font(.system(size: 20))
                    }
                    
                } else{
                    ProgressView()
                }
                
                Spacer()
                
            }
            .padding(.all)
            .onAppear{
                Music.shared.playMainMusic(action: .pause)
                Music.shared.playLevelTransitSound(completionType: completion)
                
                if !paidUser {
                    // New Level Button loads with delay.
                    withAnimation(.bouncy(duration: 2).delay(2)) {
                        showActionButton = true
                    }
                } else {
                    showActionButton = true
                }
                
                saveUserProgress(level: playedLevel)
            }
        }
    }
}


#Preview {
    
    LevelPassView(completion: .success, playedLevel: 1)
}


extension LevelPassView{
    enum completionType {
        case success
        case fail
    }
    
}

