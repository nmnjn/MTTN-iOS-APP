//
//  MusicCell.swift
//  MTTN
//
//  Created by Tushar Tapadia on 07/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import Foundation
import UIKit

class PlaylistCell: UICollectionViewCell{
    
    lazy var playlistImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var playlistName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
//        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        
        addSubview(playlistImage)
        addSubview(playlistName)
        
        _ = playlistImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        _ = playlistName.anchor(top: playlistImage.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

