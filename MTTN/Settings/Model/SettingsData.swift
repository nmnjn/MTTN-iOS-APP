//
//  SettingsData.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation

protocol SettingsType: CustomStringConvertible{
    var containsSwitch: Bool { get }
}

enum SettingsData: Int, CaseIterable, CustomStringConvertible {
    case Social
    case Settings
    case Others
    
    var description: String {
        switch self {
        case .Social:
            return "Connect with Us"
        case .Settings:
            return "App Settings"
        case .Others:
            return "Others"
        }
    }
}

enum SocialOptions: Int, CaseIterable, SettingsType {
    var containsSwitch: Bool { return false }
    
    case Instagram
    case Facebook
    case Twitter
    case Website
    case Youtube
    
    var description: String {
        switch self {
        case .Facebook:
            return "Facebook"
        case .Instagram:
            return "Instagram"
        case .Twitter:
            return "Twitter"
        case .Website:
            return "Website"
        case .Youtube:
            return "Youtube"
        }
    }
}

enum SettingsOptions: Int, CaseIterable, SettingsType {
    
    case AppIcons
    case DarkMode
//    case Notifications
    
    var containsSwitch: Bool {
        switch self {
        case .DarkMode:
            if #available(iOS 13.0, *) {
                return false
            }
            return true
//        case .Notifications:
//            return true
        case .AppIcons:
            return false
        }
    }
        
    var description: String {
        switch self {
        case .DarkMode:
            if #available(iOS 13.0, *) {
                return "Dark Mode is Supported!"
            }
            return "Dark Mode"
            
//        case .Notifications:
//            return "Notifications"
        case .AppIcons:
            return "Invert App Icon"
        }
    }
}

enum OtherOptions: Int, CaseIterable, SettingsType {
    var containsSwitch: Bool { return false }
    
    case Developer
    case PrivacyPolicy
//    case SourceCode
    case Review
    
    var description: String {
        switch self {
        case .Developer:
            return "Developer"
        case .PrivacyPolicy:
            return "Privacy Policy"
//        case .SourceCode:
//            return "Source Code"
        case .Review:
            return "Review on the App Store"
        }
    }
}
