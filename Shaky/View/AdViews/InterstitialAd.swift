//
//  InterstitialAd.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 10.11.2023.
//

import Foundation
import GoogleMobileAds

// https://medium.com/geekculture/adding-google-mobile-ads-admob-to-your-swiftui-app-in-ios-14-5-5073a2b99cf9

class InterstitialAd: NSObject {
    var interstitialAd: GADInterstitialAd?
    
    //Want to have one instance of the ad for the entire app
    //We can do this b/c you will never show more than 1 ad at once so only 1 ad needs to be loaded
    static let shared = InterstitialAd()
    
    func loadAd(withAdUnitId id: String) {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id, request: req) { interstitialAd, err in
            if let err = err {
                //TODO: ADDEBUG: Failed to load ad with error: Error Domain=com.google.admob Code=1 "Request Error: No ad to show." UserInfo={NSLocalizedDescription=Request Error: No ad to show., gad_response_info=  ** Response Info **
                print("ADDEBUG: Failed to load ad with error: \(err)")
                return
            } else{
                print("ADDEBUG: Loaded ad")
            }
            
            self.interstitialAd = interstitialAd
        }
    }
}
