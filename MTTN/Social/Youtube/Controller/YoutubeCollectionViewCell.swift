//
//  YoutubeCollectionViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 31/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Alamofire

class YoutubeCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    private let cellId = "cellID"
    weak var socialViewController: SocialViewController?
    var youtubeItems: [YoutubeItem]?{
        didSet{
            if youtubeItems?.count == 0{
                let view = UIView()
                let label = UILabel()
                label.text = "Connecting to Youtube..."
                label.font = UIFont.boldSystemFont(ofSize: 14)
                label.textColor = .lightGray
                label.textAlignment = .center
                view.addSubview(label)
                label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
                youtubeCollectionView.backgroundView = view
                return
            }
            youtubeCollectionView.backgroundView = nil
            youtubeCollectionView.reloadData()
        }
    }

    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Youtube Videos"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var youtubeCollectionView: UICollectionView = {
        let layout = SnappingLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.decelerationRate = .fast
        cv.register(YoutubeCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youtubeItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YoutubeCell
        cell.nameLabel.text = String(removeUnicodeApostropheFromString: youtubeItems![indexPath.item].snippet.title)
        let url = NSURL(string: youtubeItems![indexPath.item].snippet.thumbnails.high.url)
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
        if youtubeItems?.count == 0{
            return
        }
        let youtubeId = youtubeItems![indexPath.item].id
        if let videoId = youtubeId.videoId{
            self.socialViewController?.openYoutubeVideo(id: videoId)
        }
        if let playlistId = youtubeId.playlistId{
            self.socialViewController?.openYoutubePlaylist(id: playlistId)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            youtubeCollectionView.backgroundColor = .systemBackground
//            seperatorLineView.backgroundColor = .quaternaryLabel
        } else {
            setupTheming()
        }
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        addSubview(youtubeCollectionView)
        youtubeCollectionView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
        addSubview(seperatorLineView)
        _ = seperatorLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YoutubeCollectionViewCell: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        youtubeCollectionView.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.titleTextColor
        seperatorLineView.backgroundColor = theme.separatorColor
    }
}


extension String{
    init(removeUnicodeApostropheFromString: String){
        self.init()
        self = removeUnicodeApostropheFromString.replacingOccurrences(of: "&#39;", with: "'")
    }
}
