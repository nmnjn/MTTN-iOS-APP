//
//  AboutInfoHeader.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class AboutInfoHeader: UIView {
    
    // MARK: - Properties
    var settingsViewController: SettingsViewController?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = .red
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "index")
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Manipal The Talk Network"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "editors@manipalthetalk.org"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEmailTap)))
        return label
    }()
    
    @objc func handleEmailTap(){
        settingsViewController?.sendMailTo(email: "editors@manipalthetalk.org")
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 13.0, *) {
            usernameLabel.textColor = .label
            emailLabel.textColor = .secondaryLabel
        } else {
            setupTheming()
        }
    
        addSubview(profileImageView)
        
        _ = profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 0, widthConstant: 60, heightConstant: 0)
        
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        
        addSubview(emailLabel)
        emailLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension AboutInfoHeader: Themed{
    
    func applyTheme(_ theme: AppTheme) {
        usernameLabel.textColor = theme.titleTextColor
        emailLabel.textColor = theme.textColor
    }
    
}
