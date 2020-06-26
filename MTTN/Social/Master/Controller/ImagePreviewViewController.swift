//
//  ImagePreviewViewController.swift
//  MTTN
//
//  Created by Naman Jain on 14/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import SafariServices

class ImagePreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var imgArray = [UIImage]()
    var passedContentOffset = IndexPath()
    var social: SocialViewController?
    
    var event: UpcomingEvent?{
        didSet{
            navigationItem.rightBarButtonItems = []
            if let _ = event?.eventLink{
                let link = UIBarButtonItem(image: UIImage(named: "safari"), style: .plain, target: self, action: #selector(handleLinkTap))
                navigationItem.rightBarButtonItems?.append(link)
            }
            if let _ = event?.eventPhone{
                let phone = UIBarButtonItem(image: UIImage(named: "contact"), style: .plain, target: self, action: #selector(handlePhoneTap))
                navigationItem.rightBarButtonItems?.append(phone)
            }
            if let url = event?.eventLocation{
                if let _ = URL(string: url){
                    let location = UIBarButtonItem(image: UIImage(named: "location"), style: .plain, target: self, action: #selector(handleLocationTap))
                    navigationItem.rightBarButtonItems?.append(location)
                }
            }
        }
    }

    
    @objc func handleLinkTap(){
        if let eventUrl = event?.eventLink{
            social?.openLink(link: eventUrl)
        }
    }
    
    @objc func handlePhoneTap(){
        if let number = event?.eventPhone{
            UIApplication.shared.open(NSURL(string: "tel://\(number)")! as URL)
        }
    }
    
    @objc func handleLocationTap(){
        guard let url = URL(string: event!.eventLocation!) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
//        if let eventUrl = event?.eventLocation{
//            social?.openLink(link: eventUrl)
//        }
    }
    
    fileprivate let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.register(ImagePreviewCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isPagingEnabled = true
        collectionView.scrollToItem(at: passedContentOffset, at: .left, animated: true)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        self.view.addSubview(collectionView)
        collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImagePreviewCollectionViewCell
        cell.imageView.image=imgArray[indexPath.row]
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = collectionView.frame.size
        
        flowLayout.invalidateLayout()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = collectionView.contentOffset
        let width  = collectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        collectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.reloadData()
            
            self.collectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
}


class ImagePreviewCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    lazy var imageScrollView: UIScrollView = {
        let imageScrollView = UIScrollView()
        imageScrollView.delegate = self
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        imageScrollView.showsVerticalScrollIndicator = true
        imageScrollView.flashScrollIndicators()
        
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 4.0
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageScrollView.addGestureRecognizer(doubleTapGesture)
        
        return imageScrollView
    }()
    
    @objc var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            if UserDefaults.standard.darkModeEnabled{
                backgroundColor = .black
            }else{
                backgroundColor = .white
            }
        }
        self.addSubview(imageScrollView)
        
        imageView = UIImageView()
        imageScrollView.addSubview(imageView!)
        imageView.contentMode = .scaleAspectFit
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == 1 {
            imageScrollView.zoom(to: zoomRectForScale(scale: imageScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            imageScrollView.setZoomScale(1, animated: true)
        }
    }
    
    @objc func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: imageScrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageScrollView.frame = self.bounds
        imageView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageScrollView.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
