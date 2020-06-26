//
//  InstagramCell.swift
//  MTTN
//
//  Created by Naman Jain on 31/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import SDWebImage

class InstagamCell: UICollectionViewCell{
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var likeCounter: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            imageView.backgroundColor = .systemGroupedBackground
        } else {
            setupTheming()
        }
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(imageView)
        addSubview(likeCounter)
        _ = imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = likeCounter.anchor(top: nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 12, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension InstagamCell: Themed{
    
    func applyTheme(_ theme: AppTheme) {
        imageView.backgroundColor = theme.skeletonColor
    }
}

