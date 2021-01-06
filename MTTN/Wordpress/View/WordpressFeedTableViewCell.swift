//
//  WordpressFeedTableViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 02/04/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class WordpressFeedTableViewCell: UITableViewCell {
    
    lazy var postImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        if #available(iOS 13.0, *) {
            imageView.backgroundColor = .tertiaryLabel
        }
        return imageView
    }()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        }
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var postTitle : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        if #available(iOS 13.0, *) {
            label.textColor = .label
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var separatorLine : UIView = {
        let view = UIView()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .separator
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if UserDefaults.standard.darkModeEnabled {
//            self.selectedBackgroundView!.backgroundColor = selected ? UIColor.init(white: 0.15, alpha: 1) : UIColor.init(white: 0.15, alpha: 1)
//        }else{
//            self.selectedBackgroundView!.backgroundColor = selected ? UIColor.init(white: 0.85, alpha: 1) : UIColor.init(white: 0.85, alpha: 1)
//        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//		self.selectionStyle = .none
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
            
        }
        backgroundColor = .clear
        
        addSubview(postImage)
        addSubview(dateLabel)
        addSubview(postTitle)
        addSubview(separatorLine)
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            postImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
            postImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
            postImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 26).isActive = true
            postImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
            postImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13).isActive = true
            
            dateLabel.bottomAnchor.constraint(equalTo: postImage.bottomAnchor, constant: -16).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 16).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            dateLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
            
            postTitle.topAnchor.constraint(equalTo: postImage.topAnchor, constant: 16).isActive = true
            postTitle.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 42).isActive = true
            postTitle.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -42).isActive = true
            postTitle.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -16).isActive = true
            postTitle.font = UIFont.boldSystemFont(ofSize: 30)
            
            separatorLine.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 42).isActive = true
            separatorLine.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -42).isActive = true
            separatorLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            separatorLine.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
            
        }else{
            postImage.heightAnchor.constraint(equalToConstant: 180).isActive = true
            postImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
            postImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 26).isActive = true
            postImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
            
            dateLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            dateLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
            
            postTitle.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 16).isActive = true
            postTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 42).isActive = true
            postTitle.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -42).isActive = true
            postTitle.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -16).isActive = true
            
            separatorLine.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 42).isActive = true
            separatorLine.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -42).isActive = true
            separatorLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            separatorLine.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WordpressFeedTableViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
//        dateLabel.textColor = theme.lightTextColor
        postTitle.textColor = theme.titleTextColor
        postImage.backgroundColor = theme.skeletonColor
        separatorLine.backgroundColor = theme.separatorColor
    }
    
}
