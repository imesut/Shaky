//
//  InterstitialAdView.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 10.11.2023.
//

import Foundation
import GoogleMobileAds
import SwiftUI

// https://medium.com/geekculture/adding-google-mobile-ads-admob-to-your-swiftui-app-in-ios-14-5-5073a2b99cf9

struct InterstitialAdView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var adUnitId: String

    
    //Make's a SwiftUI View from a UIViewController
    func makeUIViewController(context: Context) -> UIViewController {
        let c = InterstitialAdViewC(isPresented: $isPresented, adUnitId: adUnitId)
        let view = UIViewController()
        
        //Show the ad after a slight delay to ensure the ad is loaded and ready to present
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            c.showAd(from: view)
        }
        return view
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}


final class InterstitialAdViewC: NSObject, GADFullScreenContentDelegate {
        
    //Here's the Ad Object we just created
    let interstitialAd = InterstitialAd.shared.interstitialAd
    var adUnitId: String
    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>, adUnitId: String) {
        self._isPresented = isPresented
        self.adUnitId = adUnitId
        super.init()
        interstitialAd?.fullScreenContentDelegate = self //Set this view as the delegate for the ad
    }
    
    //Presents the ad if it can, otherwise dismisses so the user's experience is not interrupted
    func showAd(from root: UIViewController) {
        if let ad = interstitialAd {
            ad.present(fromRootViewController: root)
        } else {
            print("Ad not ready")
            self.isPresented.toggle()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        //Prepares another ad for the next time view presented
        InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
        
        //Dismisses the view once ad dismissed
        isPresented.toggle()
    }
    
}
