//
//  TwitterCollectionViewCell.swift
//  MTTN
//
//  Created by Tushar Tapadia on 09/11/20.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Alamofire

class TwitterCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    private let cellId = "cellID"
    weak var socialViewController: SocialViewController?
    
    var twitterData: [twitterResponse]?{
        didSet{
            if twitterData?.count == 0{
                let view = UIView()
                let label = UILabel()
                label.text = "Connecting to Twitter..."
                label.font = UIFont.boldSystemFont(ofSize: 14)
                label.textColor = .lightGray
                label.textAlignment = .center
                view.addSubview(label)
                label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
                twitterCollectionView.backgroundView = view
                return
            }
            twitterCollectionView.backgroundView = nil
            twitterCollectionView.reloadData()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tweets"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var twitterCollectionView: UICollectionView = {
        let layout = SnappingLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.decelerationRate = .fast
        cv.register(TwitterCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return twitterData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TwitterCell
        let data = twitterData?[indexPath.item]
//        let trunktweet = data?.full_text.components(separatedBy: "https://")
        cell.tweetlabel.text = data?.full_text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 64, height: frame.height - 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let twitterId = twitterData?[indexPath.item].id_str ?? ""
        self.socialViewController?.openTweet(id: twitterId)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            twitterCollectionView.backgroundColor = .systemBackground
            seperatorLineView.backgroundColor = .quaternaryLabel
        } else {
            setupTheming()
        }
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        addSubview(twitterCollectionView)
        twitterCollectionView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
        addSubview(seperatorLineView)
        _ = seperatorLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TwitterCollectionViewCell: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        twitterCollectionView.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.titleTextColor
        seperatorLineView.backgroundColor = theme.separatorColor
    }
}
