//
//  AppTheme.swift
//  DarkMode
//
//  Created by Naman Jain on 28/03/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation
import UIKit

struct AppTheme {
    var appTintColor: UIColor
    
    var statusBarStyle: UIStatusBarStyle
    var keyboardAppearance: UIKeyboardAppearance
    
    var barBackgroundColor: UIColor
    var barForegroundColor: UIColor
    var backgroundColor: UIColor
    var cardColor: UIColor
    
    var titleTextColor: UIColor
    var textColor: UIColor
    var lightTextColor: UIColor
    var detailedTextColor: UIColor
    var tweetBackgroundColor:UIColor
    
    var cellHighlightColor: UIColor
    var separatorColor: UIColor
    
    var skeletonColor: UIColor
    
    var gradientColors: [UIColor]
    
    
}

extension AppTheme {
    
    private static let appTintColorLight = UIColor(rgb: 0x007aff)
    private static let appTintColorDark = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    
    
    static let light = AppTheme(
        appTintColor: appTintColorLight,
        
        statusBarStyle: .default,
        keyboardAppearance: .dark,
        
        barBackgroundColor: .white,
        barForegroundColor: appTintColorLight,
        backgroundColor: .white,
        cardColor: UIColor.init(white: 0.95, alpha: 1),
        
        titleTextColor: .black,
        textColor: UIColor(rgb: 0x555555),
        lightTextColor: UIColor(rgb: 0xAAAAAA),
        detailedTextColor: UIColor.init(white: 0.2, alpha: 1),
        tweetBackgroundColor: UIColor(rgb: 0x808080),
        
        cellHighlightColor: UIColor(rgb: 0xF4D1F2),
        separatorColor: UIColor.init(white: 0.6, alpha: 0.3),
        
        skeletonColor: UIColor(white: 0.9, alpha: 1),
        gradientColors: [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                          UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                          UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                          UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                          UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                          UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                          UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)]
        )
    
    static let dark = AppTheme(
        appTintColor: appTintColorDark,
        
        statusBarStyle: .lightContent,
        keyboardAppearance: .light,
        
        barBackgroundColor: UIColor(rgb: 0x111111),
        barForegroundColor: appTintColorDark,
        backgroundColor: .black,
        cardColor: UIColor.init(white: 0.13, alpha: 1),
        
        titleTextColor: UIColor(rgb: 0xDDDDDD),
        textColor: UIColor(rgb: 0xAAAAAA),
        lightTextColor: UIColor(rgb: 0x555555),
        detailedTextColor: UIColor.init(white: 0.8, alpha: 1),
        tweetBackgroundColor: UIColor(rgb: 0x696969),
        
        cellHighlightColor: UIColor(rgb: 0x34363D),
        separatorColor: UIColor.init(white: 0.4, alpha: 0.3),
        
        skeletonColor: UIColor(white: 0.2, alpha: 1),
        gradientColors: [UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                         UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0),
                         UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
                         UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0),
                         UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                         UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
                         UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                         UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1.0)]
    
    )
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
