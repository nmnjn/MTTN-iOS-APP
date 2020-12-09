//
//  InstagramCollectionViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 31/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Alamofire

class InstagramCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    private let cellId = "cellID"
    weak var socialViewController: SocialViewController?
    var instagramData: [InstagramData]?{
        didSet{
            if instagramData?.count == 0{
                let view = UIView()
                let label = UILabel()
                label.text = "Connecting to Instagram..."
                label.font = UIFont.boldSystemFont(ofSize: 14)
                label.textColor = .lightGray
                label.textAlignment = .center
                view.addSubview(label)
                label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
                instagramCollectionView.backgroundView = view
                return
            }
            instagramCollectionView.backgroundView = nil
            instagramCollectionView.reloadData()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Instagram Posts"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var instagramCollectionView: UICollectionView = {
        let layout = SnappingLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.decelerationRate = .fast
        cv.register(InstagamCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instagramData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InstagamCell
        let data = instagramData![indexPath.item]
        var url = NSURL(string: data.media_url)
        if data.media_type == "VIDEO"{
            if let media_url = data.thumbnail_url{
                url = NSURL(string: media_url)
            }
        }
        cell.imageView.sd_setImage(with: url! as URL, placeholderImage:nil)
        cell.likeCounter.text = ""//"♥"
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
        if instagramData?.count == 0{
            return
        }
        let url = instagramData![indexPath.item].permalink
        let webURL = NSURL(string: url)!
        let application = UIApplication.shared
        application.open(webURL as URL)
        return
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            instagramCollectionView.backgroundColor = .systemBackground
            seperatorLineView.backgroundColor = .quaternaryLabel
        } else {
            setupTheming()
        }
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        addSubview(instagramCollectionView)
        instagramCollectionView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0)
        addSubview(seperatorLineView)
        _ = seperatorLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InstagramCollectionViewCell: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        instagramCollectionView.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.titleTextColor
        seperatorLineView.backgroundColor = theme.separatorColor
    }
}
