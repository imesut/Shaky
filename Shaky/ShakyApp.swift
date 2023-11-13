//
//  ShakyApp.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 5.11.2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleMobileAds

@main
struct ShakyApp: App {
    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        InterstitialAd.shared.loadAd(withAdUnitId: "ca-app-pub-3654508956041872/4945256256")
        Music.shared.playMainMusic(action: .play)
        _ = PaidUserModel.shared.userIsPremium
      }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
