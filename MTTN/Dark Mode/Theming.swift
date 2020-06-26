//
//  Theming.swift
//  DarkMode
//
//  Created by Naman Jain on 28/03/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation


import Foundation

/// Describes a type that holds a current `Theme` and allows
/// an object to be notified when the theme is changed.
protocol ThemeProvider {
    /// Placeholder for the theme type that the app will use
    associatedtype Theme
    
    /// The current theme that is active
    var currentTheme: Theme { get }
    
    /// Subscribe to be notified when the theme changes. Handler will be
    /// remove from subscription when `object` is deallocated.
    func subscribeToChanges(_ object: AnyObject, handler: @escaping (Theme) -> Void)
}

/// Describes a type that can have a theme applied to it
protocol Themed {
    /// A Themed type needs to know about what concrete type the
    /// ThemeProvider is. So we don't clash with the protocol,
    /// let's call this associated type _ThemeProvider
    associatedtype _ThemeProvider: ThemeProvider
    
    /// Return the current app-wide theme provider
    var themeProvider: _ThemeProvider { get }
    
    /// This will be called whenever the current theme changes
    func applyTheme(_ theme: _ThemeProvider.Theme)
}

extension Themed where Self: AnyObject {
    /// This is to be called once when Self wants to start listening for
    /// theme changes. This immediately triggers `applyTheme()` with the
    /// current theme.
    func setupTheming() {
        
        applyTheme(themeProvider.currentTheme)
        themeProvider.subscribeToChanges(self) { [weak self] newTheme in
            self?.applyTheme(newTheme)
        }
    }
}

extension UserDefaults {
    public var darkModeEnabled: Bool {
        let themeSetting = string(forKey: UserDefaultsKeys.Theme.rawValue)
        return themeSetting == "dark"
    }
    
    public func setDarkMode(_ enabled: Bool) {
        set(enabled ? "dark" : "light", forKey: UserDefaultsKeys.Theme.rawValue)
    }
}

//enum UserDefaultsKeys: String {
//    case Theme
//}
