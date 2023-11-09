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
      }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
