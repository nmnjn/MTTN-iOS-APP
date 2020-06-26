//
//  DeveloperViewController.swift
//  MTTN
//
//  Created by Naman Jain on 15/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class DeveloperView: NSObject {
    
    var messages = [""]

    var settingsViewController: SettingsViewController?
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
        imageView.image = UIImage(named: "naman")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Developed with ♥ by Naman Jain"
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "If you need any help or want to work with me, shoot me an email.\n"//"Find me around campus for an\nexclusive MTTN sticker :)\n"//
        label.numberOfLines = 0
        return label
    }()
    
    lazy var instagramButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.dropShadowButton()
        button.layer.cornerRadius = 10
        button.setTitle("Instagram", for: .normal)
        button.addTarget(self, action: #selector(handleInstagramTap), for: .touchUpInside)
        return button
    }()
    
    lazy var mailButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.dropShadowButton()
        button.layer.cornerRadius = 10
        button.setTitle("Mail", for: .normal)
        button.addTarget(self, action: #selector(handleMailTap), for: .touchUpInside)
        return button
    }()
    
    @objc func handleInstagramTap(){
        handleDismiss()
        self.settingsViewController?.openInstagram(username: "nxmxnjxxn")
    }
    @objc func handleMailTap(){
        handleDismiss()
        self.settingsViewController?.sendMailTo(email: "naman17@gmail.com")
    }
    
    func showMenu() {
        
        //NotificationCenter.default.addObserver(self, selector: #selector(handleDismiss), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        if let window = UIApplication.shared.keyWindow {

            window.addSubview(blackView)
            window.addSubview(developerView)
            blackView.frame = window.frame
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            tapGesture.cancelsTouchesInView = false
            blackView.isUserInteractionEnabled = true
            blackView.addGestureRecognizer(tapGesture)
            
            
            var height: CGFloat = 335
            
            if UIDevice.current.hasNotch{
                height = 350
            }
            
            let y = window.frame.height - height
            developerView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            developerView.addSubview(developerImage)
            developerImage.centerXAnchor.constraint(equalTo: developerView.centerXAnchor).isActive = true
            _ = developerImage.anchor(top: developerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
            
            developerView.addSubview(titleLabel)
            titleLabel.centerXAnchor.constraint(equalTo: developerView.centerXAnchor).isActive = true
            _ = titleLabel.anchor(top: developerImage.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 250, heightConstant: 0)
            
            developerView.addSubview(messageLabel)
            messageLabel.centerXAnchor.constraint(equalTo: developerView.centerXAnchor).isActive = true
            _ = messageLabel.anchor(top: titleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: 0)
            
            developerView.addSubview(instagramButton)
            instagramButton.centerXAnchor.constraint(equalTo: developerView.centerXAnchor, constant: -66).isActive = true
            _ = instagramButton.anchor(top: messageLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
            
            developerView.addSubview(mailButton)
            mailButton.centerXAnchor.constraint(equalTo: developerView.centerXAnchor, constant: 66).isActive = true
            _ = mailButton.anchor(top: messageLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 50)
            
            
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.developerView.frame = CGRect(x: 0, y: y, width: self.developerView.frame.width, height: self.developerView.frame.height)
                
            }, completion: { (_) in
//                self.blackView.removeFromSuperview()
//                self.developerView.removeFromSuperview()
//                NotificationCenter.default.removeObserver(UIDevice.orientationDidChangeNotification)
            })
        }
    }
    
    @objc func handleDismiss() {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
        
            if let window = UIApplication.shared.keyWindow {
                self.developerView.frame = CGRect(x: 0, y: window.frame.height, width: self.developerView.frame.width, height: self.developerView.frame.height)
                }
        }, completion: nil)
    }
    
    override init() {
        super.init()
        //start doing something here maybe....
    }
    
}
