//
//  SLCMTableViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 06/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Pastel

class SLCMTableViewCell: UITableViewCell {
    
    let viewController = UIViewController()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "about")
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowOpacity = 1
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 30)
        }
        label.text = "Developed with\n♥ in Manipal"
        return label
    }()
    
    lazy var waitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 0
        label.text = ""
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        return label
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
        
        // Custom Color
        view.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                            UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                            UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                            UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                            UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                            UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                            UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        view.startAnimation()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        addSubview(pastelView)
        addSubview(notesLabel)
        addSubview(nameLabel)
        addSubview(waitLabel)
        
        _ = pastelView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = notesLabel.anchor(top: nil, left: pastelView.leftAnchor, bottom: pastelView.bottomAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 12, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        _ = nameLabel.anchor(top: pastelView.topAnchor, left: pastelView.leftAnchor, bottom: nil, right: pastelView.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = waitLabel.anchor(top: pastelView.topAnchor, left: pastelView.leftAnchor, bottom: pastelView.bottomAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
