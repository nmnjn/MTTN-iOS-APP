//
//  YoutubeCell.swift
//  MTTN
//
//  Created by Naman Jain on 31/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import SDWebImage
class YoutubeCell: UICollectionViewCell{
    
    var youtubeItem: YoutubeItem?{
        didSet{
            guard let item = youtubeItem else {
                return
            }
            let url = NSURL(string: item.snippet.thumbnails.high.url)
            imageView.sd_setImage(with: url! as URL, completed: nil)
            nameLabel.text = String(encodedString: item.snippet.title)
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
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
        addSubview(nameLabel)
        _ = imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 85)
        _ = nameLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension YoutubeCell: Themed{
    
    func applyTheme(_ theme: AppTheme) {
        nameLabel.textColor = theme.titleTextColor
//        imageView.backgroundColor = theme.skeletonColor
    }
}
