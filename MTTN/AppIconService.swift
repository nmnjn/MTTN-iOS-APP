//
//  AppIconService.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit


class AppIconService{
    
    let application = UIApplication.shared
    
    enum AppIcon: String {
        case PrimaryAppIcon
        case DarkAppIcon
        case GreenAppIcon
        case CrewAppIcon
    }
    
    func changeAppIcon(to appIcon: AppIcon){
        let appIconName: String? = appIcon == .PrimaryAppIcon ? nil: appIcon.rawValue
        application.setAlternateIconName(appIconName)
    }
}
