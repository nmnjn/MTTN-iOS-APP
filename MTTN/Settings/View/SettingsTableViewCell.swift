//
//  SettingsTableViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var settingsType: SettingsType? {
        didSet{
            guard let settingsType = settingsType else{
                return
            }
            textLabel?.text = settingsType.description
            switchControl.isHidden = !settingsType.containsSwitch
            if settingsType.description == "Dark Mode"{
                switchControl.isOn = UserDefaults.standard.darkModeEnabled
                switchControl.addTarget(self, action: #selector(darkModeValueChanged(_:)), for: .valueChanged)
            }else if settingsType.description == "Notifications"{
                switchControl.isOn = false
                switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
            }
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if #available(iOS 13.0, *) {
            
        } else {
            if UserDefaults.standard.darkModeEnabled {
                self.selectedBackgroundView!.backgroundColor = selected ? UIColor.init(white: 0.15, alpha: 1) : UIColor.init(white: 0.15, alpha: 1)
            }else{
                self.selectedBackgroundView!.backgroundColor = selected ? UIColor.init(white: 0.85, alpha: 1) : UIColor.init(white: 0.85, alpha: 1)
            }
        }

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
            self.selectedBackgroundView = UIView()
        }
        backgroundColor = .clear
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSwitchAction(sender: UISwitch){
        if sender.isOn {
            print("turned on")
        }else{
            print("turned off")
        }
    }
    
}

extension SettingsTableViewCell: Themed{
    func applyTheme(_ theme: AppTheme) {
        textLabel?.textColor = theme.titleTextColor
    }
    @objc func darkModeValueChanged(_ sender: UISwitch) {
        UserDefaults.standard.setDarkMode(sender.isOn)
        AppThemeProvider.shared.currentTheme = sender.isOn ? .dark : .light
        UserDefaults.standard.synchronize()
    }
}
