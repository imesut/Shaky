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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["b98b3d610612a69b8dad9e7cdefd2cb3"]
        InterstitialAd.shared.loadAd(withAdUnitId: "ca-app-pub-3654508956041872/4945256256")
        Music.shared.playMainMusic(action: .play)
        _ = PaidUserModel.shared.userIsPremium
        return true
    }
}


@main
struct ShakyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init() {
//        FirebaseApp.configure()
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["b98b3d610612a69b8dad9e7cdefd2cb3"]
//        InterstitialAd.shared.loadAd(withAdUnitId: "ca-app-pub-3654508956041872/4945256256")
//        Music.shared.playMainMusic(action: .play)
//        _ = PaidUserModel.shared.userIsPremium
//      }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
