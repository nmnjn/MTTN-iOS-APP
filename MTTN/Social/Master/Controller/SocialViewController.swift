//
//  SocialViewController.swift
//  MTTN
//
//  Created by Naman Jain on 30/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import AudioToolbox
import FirebaseDatabase
import Alamofire
import SafariServices
import FirebaseAuth
import Disk
import SDWebImage


class SocialViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    fileprivate let headerId = "headerId"
    fileprivate let youtubeCellId = "youtubeCellId"
    fileprivate let instagramCellId = "instagramCellId"
    fileprivate let upcomingEventsCellId = "upcomingEventsCellId"
    fileprivate let noirSelectCellId = "noirSelectCellId"
    fileprivate let blitzCellId = "blitzCellId"
    fileprivate let noirCardIsActivated = "noirCardIsActivated"
    
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var ref : DatabaseReference?
    fileprivate var shouldRefresh : Bool = true
    
    var instagramData: [InstagramData]?{
        didSet{
        }
    }
    var youtubeItems: [YoutubeItem]?{
        didSet{
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            setupTheming()
        }
        setupNavigationBar()
        setupAnimation()
        setupCollectionView()
        self.youtubeItems = self.getYoutubeItemsFromCache()
        self.instagramData = self.getInstagramPostsFromCache()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
        //Time consuming task here
            self.getInstagramPosts()
            self.getYoutubeVideos()
        }
//        DispatchQueue.main.async {

//        }
    }
    
    fileprivate func setupNavigationBar(){
        navigationItem.title = "MTTN Social"
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    fileprivate func setupAnimation(){
        if !UserDefaults.standard.bool(forKey: "animation"){
            handleAnimation(num: 40)
            UserDefaults.standard.set(true, forKey: "animation")
            UserDefaults.standard.synchronize()
        }
    }
    
    fileprivate func setupCollectionView(){
//        refreshControl.addTarget(self, action: #selector(refreshSocial), for: UIControl.Event.valueChanged)
//        collectionView.refreshControl = refreshControl
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(YoutubeCollectionViewCell.self, forCellWithReuseIdentifier: youtubeCellId)
        collectionView.register(InstagramCollectionViewCell.self, forCellWithReuseIdentifier: instagramCellId)
        collectionView.register(UpcomingEventsCollectionViewCell.self, forCellWithReuseIdentifier: upcomingEventsCellId)
        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    @objc fileprivate func refreshSocial() {
        print("refresh social feed")
//        getYoutubeVideos()
//        getInstagramPosts()
        collectionView.refreshControl?.endRefreshing()
        AudioServicesPlaySystemSound(1519)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: upcomingEventsCellId, for: indexPath) as! UpcomingEventsCollectionViewCell
            cell.socialViewController = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: instagramCellId, for: indexPath) as! InstagramCollectionViewCell
            cell.socialViewController = self
            cell.instagramData = self.instagramData ?? []
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: youtubeCellId, for: indexPath) as! YoutubeCollectionViewCell
            cell.socialViewController = self
            cell.youtubeItems = self.youtubeItems ?? []
            return cell
        default:
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item{
        case 0:
            return CGSize(width: view.frame.width, height: 250)
        case 1:
            return CGSize(width: view.frame.width, height: 305)
        case 2:
            return CGSize(width: view.frame.width, height: 180)
        default:
            return CGSize(width: view.frame.width, height: 200)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
    func saveInstagramToCache(data: [InstagramData]){
        do{
            try Disk.save(data, to: .caches, as: "insta.json")
        }catch let error{
            print(error)
        }
    }
    
    func saveYoutubeToCache(data: [YoutubeItem]){
        do{
            try Disk.save(data, to: .caches, as: "youtube.json")
        }catch let error{
            print(error)
        }
    }
    
    func getInstagramPostsFromCache() -> [InstagramData]? {
        do{
            let retrievedData = try Disk.retrieve("insta.json", from: .caches, as: [InstagramData].self)
            return retrievedData
        }catch{
            return nil
        }
    }
    
    func getYoutubeItemsFromCache() -> [YoutubeItem]? {
        do{
            let retrievedData = try Disk.retrieve("youtube.json", from: .caches, as: [YoutubeItem].self)
            return retrievedData
        }catch{
            return nil
        }
    }
    
    func getInstagramPosts(){
        print("Getting Instagram Posts")
        guard let urlString = UserDefaults.standard.string(forKey: "Instagram") else{
            print("***** UNABLE TO GET INSTAGRAM API LINK *****")
            return
        }
        Alamofire.request(urlString, method: .get, parameters: nil).responseJSON { [weak self] response in
            guard let strongSelf = self else{
                return
            }
            
            switch response.result {
            case .success:
                if let data = response.data{
                    do{
                        let response = try JSONDecoder().decode(InstagramResponse.self, from: data)
                        strongSelf.instagramData = response.data
                        strongSelf.saveInstagramToCache(data: response.data)
                        DispatchQueue.main.async(execute: {
                            let indexPath = IndexPath(item: 1, section: 0)
                            strongSelf.collectionView?.reloadItems(at: [indexPath])
                            strongSelf.refreshControl.endRefreshing()
                        })
                    }catch let error{
                        print(error)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getYoutubeVideos(){
        print("Getting YouTube Videos")
        guard let urlString = UserDefaults.standard.string(forKey: "YouTube") else{
            print("***** UNABLE TO GET YOUTUBE API LINK *****")
            return
        }
        Alamofire.request(urlString, method: .get, parameters: nil).responseJSON { [weak self] response in
            guard let strongSelf = self else{
                return
            }
            switch response.result {
            case .success:
                if let data = response.data{
                    do{
                        let response = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                        strongSelf.youtubeItems = response.items
                        strongSelf.saveYoutubeToCache(data: response.items)
                        DispatchQueue.main.async(execute: {
                            let indexPath = IndexPath(item: 2, section: 0)
                            strongSelf.collectionView?.reloadItems(at: [indexPath])
                            strongSelf.refreshControl.endRefreshing()
                        })
                    }catch let error{
                        print(error)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func presentImage(event: UpcomingEvent){
        if let imgURL = event.imageUrl {
            if SDImageCache.shared.diskImageDataExists(withKey: imgURL){
                if let image = SDImageCache.shared.imageFromCache(forKey: imgURL) {
                    let vc = ImagePreviewViewController()
                    vc.social = self
                    vc.imgArray.append(image)
                    vc.event = event
                    vc.passedContentOffset = [0, 0]
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func openYoutubeVideo(id: String){
        let appURL = NSURL(string: "youtube://\(id)")!
        let webURL = NSURL(string:"http://www.youtube.com/watch?v=\(id)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            openLink(link: "\(webURL)")
        }
    }
    
    func openYoutubePlaylist(id: String){
        let webURL = NSURL(string:"https://www.youtube.com/playlist?list=\(id)")!
            openLink(link: "\(webURL)")
    }
    
    func openLink(link : String){
        let url = URL(string: link)
        let svc = SFSafariViewController(url: url!)
        if UserDefaults.standard.darkModeEnabled{
            svc.preferredBarTintColor = .black
            svc.preferredControlTintColor = .white
        }
        present(svc, animated: true, completion: nil)
    }
}

//MARK:- Theming Protocols
extension SocialViewController: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        collectionView.backgroundColor = theme.backgroundColor
        refreshControl.tintColor = theme.titleTextColor
    }
    
    @objc func darkModeValueChanged(_ sender: UISwitch) {
        UserDefaults.standard.setDarkMode(sender.isOn)
        AppThemeProvider.shared.currentTheme = sender.isOn ? .dark : .light
        UserDefaults.standard.synchronize()
    }
}

//MARK:- Animation Functions
extension SocialViewController{
    
    @objc func handleAnimation(num: Int) {
        (0...num).forEach { (_) in
            generateAnimatedViews(top: drand48() > 0.5 ? true : false)
        }
        AudioServicesPlaySystemSound(1519)
    }
    
    fileprivate func generateAnimatedViews(top: Bool) {
        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "thumbs_up") : #imageLiteral(resourceName: "heart")
        let imageView = UIImageView(image: image)
        let dimension = 20 + drand48() * 30
        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = customPath().cgPath
        animation.duration = 1 + drand48() * 4
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        imageView.layer.add(animation, forKey: nil)
        if top {
            UIApplication.shared.keyWindow?.addSubview(imageView)
        }else {
            view.addSubview(imageView)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            imageView.removeFromSuperview()
        }
    }
    @objc func customPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: view.frame.width/2, y: view.frame.height+50))
        let randomYShift = arc4random_uniform(UInt32(Int(view.frame.width+10)))
        let endPoint = CGPoint(x: Int(randomYShift), y: -50)
        
        
        let cp1 = CGPoint(x: Int(randomYShift), y: 0)
        let cp2 = CGPoint(x: Int(randomYShift), y: 0)
        
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        return path
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let thresh = abs(contentHeight - scrollView.frame.height)
        if #available(iOS 13.0, *) {
            if UIDevice.current.hasNotch{
                if offY > thresh + 20 && offY < thresh + 35{
                    handleAnimation(num: 2)
                }
            }else{
                if offY > thresh + 80 && offY < thresh + 95{
                    handleAnimation(num: 2)
                }
            }
        }else{
            if offY > thresh + 55 && offY < thresh + 70{
                handleAnimation(num: 2)
            }
        }

    }
}
