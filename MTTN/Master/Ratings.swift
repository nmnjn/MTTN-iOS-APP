//
//  Ratings.swift
//  MTTN
//
//  Created by Naman Jain on 14/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import StoreKit
import UIKit

struct StoreKitHelper{
    
    static let numberOfTimesLaunchedKey = "numberOfTimesLauched"
    static let lastVesionKey = "lastVersion"
    
    static func displayRequestRatings(){
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return
        }
        
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: StoreKitHelper.lastVesionKey)
        let numberOfTimesLaunched: Int = UserDefaults.standard.integer(forKey: StoreKitHelper.numberOfTimesLaunchedKey)
        
        if numberOfTimesLaunched > 10 && currentVersion != lastVersionPromptedForReview {
            SKStoreReviewController.requestReview()
            UserDefaults.standard.set(currentVersion, forKey: StoreKitHelper.lastVesionKey)
        }
    }
    
    static func incrementNumberOfTImesLaunched(){
        let numberOfTimeLaunched: Int = UserDefaults.standard.integer(forKey: StoreKitHelper.numberOfTimesLaunchedKey) + 1
        UserDefaults.standard.set(numberOfTimeLaunched, forKey: StoreKitHelper.numberOfTimesLaunchedKey)
        UserDefaults.standard.synchronize()
    }
}

