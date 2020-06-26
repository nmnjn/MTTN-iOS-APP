//
//  AttendanceTableViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Pastel

class AttendanceTableViewCell: UITableViewCell {
    
    let viewController = UIViewController()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var pastelView: PastelView = {
        let view = PastelView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        // Custom Direction
        view.startPastelPoint = .bottomLeft
        view.endPastelPoint = .topRight
        
        
        // Custom Duration
        view.animationDuration = 1.5
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 22)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 27)
        }
        
        return label
    }()
    lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 42)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 52)
        }
        
        return label
    }()
    
    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        if viewController.isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 13)
        }
        else{
            label.font = UIFont.systemFont(ofSize: 16)
        }
        return label
    }()
    
    lazy var moreInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        if viewController.isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 11)
        }
        else{
            label.font = UIFont.systemFont(ofSize: 11)
        }
        return label
    }()
    
    lazy var subjectMarksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        return label
    }()
    
    lazy var marksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 22)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 28)
        }
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .clear
//        addSubview(backgroundImageView)
        addSubview(pastelView)
        addSubview(nameLabel)
        addSubview(notesLabel)
        addSubview(percentageLabel)
        addSubview(moreInfoLabel)
        addSubview(marksLabel)
        addSubview(subjectMarksLabel)
        _ = pastelView.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = nameLabel.anchor(top: pastelView.topAnchor, left: pastelView.leftAnchor, bottom: nil, right: pastelView.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        _ = notesLabel.anchor(top: nil, left: pastelView.leftAnchor, bottom: pastelView.bottomAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 12, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        _ = percentageLabel.anchor(top: nil, left: pastelView.leftAnchor, bottom: notesLabel.topAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: -5, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        _ = moreInfoLabel.anchor(top: nil, left: pastelView.leftAnchor, bottom: pastelView.bottomAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 12, rightConstant: frame.width/2, widthConstant: 0, heightConstant: 0)
        _ = marksLabel.anchor(top: nil, left: pastelView.leftAnchor, bottom: moreInfoLabel.topAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: frame.width/2, widthConstant: 0, heightConstant: 0)
        _ = subjectMarksLabel.anchor(top: nil, left: pastelView.leftAnchor, bottom: marksLabel.topAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: frame.width/2, widthConstant: 0, heightConstant: 0)
    }
}
