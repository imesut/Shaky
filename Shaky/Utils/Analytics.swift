//
//  Analytics.swift
//  Shaky
//
//  Created by Mesut Yılmaz on 9.11.2023.
//

import Foundation
import Firebase
import FirebaseAnalytics

func logEvent(eventName : String, params : [String : NSObject]){
    Analytics.logEvent(eventName, parameters: params)
}
