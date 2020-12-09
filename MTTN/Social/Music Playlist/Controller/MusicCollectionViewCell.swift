//
//  MusicCollectionViewController.swift
//  MTTN
//
//  Created by Tushar Tapadia on 07/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import Disk

class MusicCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let cellId = "cellID"
    weak var socialViewController: SocialViewController?
    var playlistFeed: [playlistData]?{
        didSet{
            if playlistFeed?.count == 0{
                let view = UIView()
                let label = UILabel()
                label.text = "Connecting to Playlist Portal..."
                label.font = UIFont.boldSystemFont(ofSize: 14)
                label.textColor = .lightGray
                label.textAlignment = .center
                view.addSubview(label)
                label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
                playlistCollectionView.backgroundView = view
                return
            }
            playlistCollectionView.backgroundView = nil
            playlistCollectionView.reloadData()
        }
    }
   
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Playlists"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    
    lazy var playlistCollectionView: UICollectionView = {
        let layout = SnappingLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.decelerationRate = .fast
        cv.register(PlaylistCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlistFeed?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlaylistCell
        let data = playlistFeed?[indexPath.item]
        cell.playlistImage.sd_setImage(with: URL(string: data?.imgurl ?? ""), placeholderImage: UIImage(named: "logo.png"))
        cell.playlistName.text = data?.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: frame.height - 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = playlistFeed?[indexPath.item]
        let a = data?.link2
        let s = data?.link1
        let y = data?.link3
        socialViewController?.tabMe(spotify: s!,apple:a!,youtube:y!)
    }

    
    override init(frame: CGRect) {
            super.init(frame: frame)
            if #available(iOS 13.0, *) {
                playlistCollectionView.backgroundColor = .systemBackground
                seperatorLineView.backgroundColor = .quaternaryLabel
            } else {
                setupTheming()
            }
            setupLayout()
        }
    
    
    
    fileprivate func setupLayout(){
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        addSubview(playlistCollectionView)
        playlistCollectionView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
        addSubview(seperatorLineView)
        _ = seperatorLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MusicCollectionViewCell: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        playlistCollectionView.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.titleTextColor
        seperatorLineView.backgroundColor = theme.separatorColor
    }
}



