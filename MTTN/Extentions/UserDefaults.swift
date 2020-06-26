//
//  UserDefaults.swift
//  MTTN
//
//  Created by Naman Jain on 13/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case Theme
        case isLoggedIn
    }
    @objc func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    @objc func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}
