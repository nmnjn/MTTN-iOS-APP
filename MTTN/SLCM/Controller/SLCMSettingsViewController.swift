//
//  SLCMSettingsViewController.swift
//  MTTN
//
//  Created by Naman Jain on 15/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftMessages


class SLCMSettingsViewController: NSObject {
    
    weak var slcmViewController: SLCMViewController?
    
    let blackView:  UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    let developerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let developerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar2")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        label.text = "Low Attendance Alerts:\nWe will send you a notification if your attendance goes below 80%."
        label.numberOfLines = 0
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.dropShadowButton()
        button.layer.cornerRadius = 10
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(handleLogoutTap), for: .touchUpInside)
        button.tintColor = .red
        return button
    }()
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    @objc func handleLogoutTap(){
        handleDismiss()
        self.slcmViewController?.handleLogout()
    }
    
    func showMenu() {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleDismiss), name: UIDevice.orientationDidChangeNotification, object: nil)

        
        switchControl.isOn = UserDefaults.standard.bool(forKey: "userHasEnabledFetch")
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        if UserDefaults.standard.bool(forKey: "isSis"){
                    if let userName = UserDefaults.standard.string(forKey: "SISUser"){
                        let userNameArray = userName.split(separator: " ")
                        if let parameter = UserDefaults.standard.dictionary(forKey: "parameter"){
                            if let regNumber = parameter["username"] as? String{
                                titleLabel.text = "\(userNameArray[0]) - \(regNumber)"
                            }
                        }else {
                           titleLabel.text = userName
                        }
                    }
        }else{
                    if let userName = UserDefaults.standard.string(forKey: "SLCMUser"){
                        let userNameArray = userName.split(separator: " ")
                        if let parameter = UserDefaults.standard.dictionary(forKey: "parameter"){
                            if let regNumber = parameter["username"] as? String{
                                if regNumber == "170906440"{
                                    titleLabel.text = "Chocolate - \(regNumber)"
                                }else{
                                    titleLabel.text = "\(userNameArray[0]) - \(regNumber)"
                                }
                            }
                        }else {
                           titleLabel.text = userName
                        }
                    }
        }
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(blackView)
            window.addSubview(developerView)
            blackView.frame = window.frame
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            tapGesture.cancelsTouchesInView = false
            blackView.isUserInteractionEnabled = true
            blackView.addGestureRecognizer(tapGesture)
            

            var height: CGFloat = 320
            
            if UIAccessibility.isBoldTextEnabled{
                height = 330
            }
            
            if UIDevice.current.hasNotch{
                height = 330
                
                if UIAccessibility.isBoldTextEnabled{
                    height = 340
                }
            }
            
            let y = window.frame.height - height
            developerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            developerView.addSubview(developerImage)
            developerImage.centerXAnchor.constraint(equalTo: developerView.centerXAnchor).isActive = true
            _ = developerImage.anchor(top: developerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
            
            developerView.addSubview(titleLabel)
            titleLabel.centerXAnchor.constraint(equalTo: developerView.centerXAnchor).isActive = true
            _ = titleLabel.anchor(top: developerImage.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 250, heightConstant: 0)
            
            developerView.addSubview(containerView)
            containerView.centerXAnchor.constraint(equalTo: developerView.centerXAnchor).isActive = true
            _ = containerView.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: 0)

            containerView.addSubview(switchControl)
            switchControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            _ = switchControl.anchor(top: nil, left: nil, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 50, heightConstant: 0)
            
            containerView.addSubview(messageLabel)
            _ = messageLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: switchControl.leftAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            
            developerView.addSubview(logoutButton)
            logoutButton.centerXAnchor.constraint(equalTo: developerView.centerXAnchor, constant: 0).isActive = true
            _ = logoutButton.anchor(top: containerView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
            
            
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.developerView.frame = CGRect(x: 0, y: y, width: self.developerView.frame.width, height: self.developerView.frame.height)
                
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.developerView.frame = CGRect(x: 0, y: window.frame.height, width: self.developerView.frame.width, height: self.developerView.frame.height)
            }
        }, completion: { (_) in
            self.blackView.removeFromSuperview()
            self.developerView.removeFromSuperview()
//            NotificationCenter.default.removeObserver(UIDevice.orientationDidChangeNotification)
        })
    }
    
    override init() {
//        super.init()
        //start doing something here maybe....
    }
    
    func demoCentered() {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
            messageView.configureContent(title: "Oh No!", body: "You need to turn on the app notifications for this feature to work!", iconImage: nil, iconText: "🦄", buttonImage: nil, buttonTitle: "Go to Settings") { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                SwiftMessages.hide()
            }
//            messageView.configureContent(title: "Oh No!", body: "We are facing problems connecting to SLCM. Your attendance was last updated on 16th October at 5:48 PM.")
//            messageView.button?.isHidden = true
//            messageView.backgroundView.layer.cornerRadius = 10
            var config = SwiftMessages.defaultConfig
//            messageView.configureTheme(.warning, iconStyle: .light)
            messageView.configureDropShadow()
//            messageView.accessibilityPrefix = "warning"
        config.presentationStyle = .center
            config.duration = .forever
            config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
            config.presentationContext  = .window(windowLevel: .statusBar)
            SwiftMessages.show(config: config, view: messageView)
        }
    
    @objc func handleSwitchAction(sender: UISwitch){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let err = error{
                print(err)
            }
            DispatchQueue.main.async {
                if success{
                    if sender.isOn {
                        UserDefaults.standard.set(true, forKey: "userHasEnabledFetch")
                        UserDefaults.standard.synchronize()
                    }else{
                        UserDefaults.standard.set(false, forKey: "userHasEnabledFetch")
                        UserDefaults.standard.synchronize()
                    }
                }else{
                    print("Open Settings")
                    self.demoCentered()
                    sender.isOn = false
                }
                
            }
        }

    }
}
