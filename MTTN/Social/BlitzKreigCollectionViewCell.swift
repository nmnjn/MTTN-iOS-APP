//
//  BlitzKreigCollectionViewController.swift
//  MTTN
//
//  Created by Naman Jain on 29/07/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

import UIKit
import Alamofire
import Firebase

struct BlitzVideo {
    var youtubeUrl : String?
    var thumbnailUrl : String?
    var title: String?
}

class BlitzKreigCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    private let cellId = "cellID"
    weak var socialViewController: SocialViewController?
    fileprivate var ref: DatabaseReference?
    var youtubeItems = [BlitzVideo]()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Blitzkrieg Dance Crew India"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var youtubeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(YoutubeCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youtubeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YoutubeCell
        cell.nameLabel.text = youtubeItems[indexPath.item].title ?? ""
        let url = NSURL(string: youtubeItems[indexPath.item].thumbnailUrl ?? "")
        cell.imageView.sd_setImage(with: url! as URL, placeholderImage:nil)
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
        if let youtubeLink = youtubeItems[indexPath.item].youtubeUrl {
            self.socialViewController?.openLink(link: youtubeLink)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
        }
        setupLayout()
        fetchVideos()
    }
    
    fileprivate func setupLayout(){
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        addSubview(youtubeCollectionView)
        youtubeCollectionView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        addSubview(seperatorLineView)
        _ = seperatorLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func fetchVideos(){
        ref = Database.database().reference()
        ref?.child("Blitz").observe(.childAdded, with: { (snapshot) in
            var video = BlitzVideo()
            let imageName = snapshot.childSnapshot(forPath: "thumbnailUrl").value as? String
            if let actualImageName = imageName {
                video.thumbnailUrl = actualImageName
            }
            let name = snapshot.childSnapshot(forPath: "title").value as? String
            if let actualName = name {
                video.title = actualName
            }
            let link = snapshot.childSnapshot(forPath: "youtubeUrl").value as? String
            if let actualLink = link {
                video.youtubeUrl = actualLink
            }
            self.youtubeItems.insert(video, at: 0)
            self.youtubeCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        })
    }
}

extension BlitzKreigCollectionViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        youtubeCollectionView.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.titleTextColor
        seperatorLineView.backgroundColor = theme.separatorColor
    }
}
