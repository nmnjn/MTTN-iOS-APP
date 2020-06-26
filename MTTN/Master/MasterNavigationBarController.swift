//
//  MasterNavigationBarController.swift
//  MTTN
//
//  Created by Naman Jain on 02/04/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class MasterNavigationBarController: UINavigationController {
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? super.preferredStatusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationBar.isTranslucent = false
        if #available(iOS 13.0, *) {
            navigationBar.tintColor = UIColor(named: "directoryColor")
            view.backgroundColor = .systemBackground
        } else {
            setupTheming()
        }
    }
}

extension MasterNavigationBarController: Themed {
    func applyTheme(_ theme: AppTheme) {
        themedStatusBarStyle = theme.statusBarStyle
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = theme.titleTextColor
        navigationBar.barTintColor = theme.barBackgroundColor
        navigationBar.tintColor = theme.barForegroundColor
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.titleTextColor
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.largeTitleTextAttributes = titleTextAttributes
    }
}
