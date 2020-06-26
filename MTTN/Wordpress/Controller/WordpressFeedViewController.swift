//
//  ViewController.swift
//  MTTN
//
//  Created by Naman Jain on 02/04/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//


import UIKit
import Alamofire
import AudioToolbox
import SDWebImage
import SwiftMessages
import UserNotifications

class WordpressFeedViewController: UITableViewController {
    var posts = [postDetails]()
    var downloadedPosts = [postDetails]()
    var page = 1
    var fetchData = false
    var fail = false
    var refreshController = UIRefreshControl()
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.backgroundColor = .orange
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshController.endRefreshing()
    }
    
    fileprivate func setupNavigationBar() {
        
        navigationItem.title = "MTTN Feed"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(handleInfoButtonTapped), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    @objc fileprivate func handleInfoButtonTapped(){
        let settingsViewController = SettingsViewController()
        settingsViewController.wordpressFeedViewController = self
        settingsViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    fileprivate func setupTableView() {
        
        tableView.register(WordpressFeedTableViewCell.self, forCellReuseIdentifier: "WordpressFeedTableViewCellId")
        tableView.register(WordpressFeedLoaderViewCell.self, forCellReuseIdentifier: "WordpressFeedLoaderViewCellId")
        
        refreshController.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshController
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 295
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
        func showNotificationPopup() {
            let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
                messageView.configureContent(title: "Hey there!", body: "Thanks for downloading the MTTN App.\nWe hope you will enjoy using it just as much as we enjoyed building it!\n\nTo further enhance the experience, please turn on Push Notifications. We promise to never spam!", iconImage: nil, iconText: "🦄", buttonImage: nil, buttonTitle: "Turn on Notifications") { _ in
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
                        if let err = error{
                            print(err)
                        }
                        UserDefaults.standard.set(success, forKey: "userHasEnabledFetch")
                        UserDefaults.standard.synchronize()
                        SwiftMessages.hide()
                    }
                }
    //            messageView.configureContent(title: "Oh No!", body: "We are facing problems connecting to SLCM. Your attendance was last updated on 16th October at 5:48 PM.")
    //            messageView.button?.isHidden = true
    //            messageView.backgroundView.layer.cornerRadius = 10
                var config = SwiftMessages.defaultConfig
    //            messageView.configureTheme(.warning, iconStyle: .light)
                messageView.configureDropShadow()
    //            messageView.accessibilityPrefix = "warning"
            config.presentationStyle = .center
                config.duration = .forever
            config.dimMode = .color(color: UIColor(white: 0, alpha: 0.55), interactive: true)
//            config.dimMode = .blur(style: .dark, alpha: 0.95, interactive: true)
                config.presentationContext  = .window(windowLevel: .statusBar)
                SwiftMessages.show(config: config, view: messageView)
            UserDefaults.standard.set(true, forKey: "firstInteractionFinished")
            UserDefaults.standard.synchronize()
            }
    
    override func viewDidAppear(_ animated: Bool) {
        if posts.count == 0 {
            _ = getData(filePath: savedPostsFilePath)
            refreshData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.refreshController.beginRefreshing()
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-(self.refreshController.frame.size.height)), animated: false)
            }
        }
        
        if !UserDefaults.standard.bool(forKey: "firstInteractionFinished"){
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk()
            self.showNotificationPopup()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offY > abs(contentHeight - scrollView.frame.height) {
            if !fetchData{
                AudioServicesPlaySystemSound(1519)
                fetchNewData()
            }
        }
    }
    
    private func fetchNewData() {
        self.downloadedPosts = self.posts
        self.fail = false
        self.fetchData = true
        self.page = (self.posts.count / 10) + 1
        DispatchQueue.main.async {
            self.getPosts()
        }
        
    }
    
    @objc func refreshData() {
        AudioServicesPlaySystemSound(1519)
        if Network.isConnectedToNetwork() == true {
            self.fail = false
            self.page = 1
            self.downloadedPosts = []
            self.refreshController.beginRefreshing()
            DispatchQueue.main.async {
                self.getPosts()
            }
        }else{
            self.fail = true
            DispatchQueue.main.async {
                FloatingMessage().floatingMessage(Message: "No Internet Connection", onPresentation: {
                    self.refreshController.endRefreshing()
                }, onDismiss: {
                    return
                })
            }
        }

    }

    
    private func saveData(data: [postDetails], filePath: String){
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }
    
    private func getData(filePath: String) -> Bool{
        if let retrievedData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [postDetails]{
            posts = retrievedData
            self.tableView.reloadData()
            print("***SAVED WORDPRESS DATA RETRIEVED***")
            return true
        }
        return false
    }
    
    private func getPosts() {
        Alamofire.request(feedURL + "\(page)", method: .get, parameters: nil).responseJSON { response in
            guard let items = response.result.value as? [[String:AnyObject]] else {
                print("Request failed with error. Url: \(feedURL)\(self.page)")
                DispatchQueue.main.async{
                    FloatingMessage().floatingMessage(Message: "Unable to Fetch Posts", onPresentation: {
                        self.fail = true
                        self.fetchData = false
                        self.tableView.reloadData()
                    }, onDismiss: {
                        self.tableView.refreshControl?.endRefreshing()
                    })
                    AudioServicesPlaySystemSound(1521)
                }
                return
            }
            for item in items{
                let post = postDetails()
                if let title_json = item["title"] as? [String: AnyObject] {
                    if let encodedTitle = title_json["rendered"] as? String {
                        let title = String(encodedString: encodedTitle)
                        post.title = title
                    }
                }
                if let content_json = item["content"] as? [String: AnyObject] {
                    if let content = content_json["rendered"] as? String {
                        let webContent : String = "<h1>\(post.title!)</h1>" + content
                        post.renderedContent = webContent
                    }
                }
                if let date = item["date"] as? String {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let dateDate = formatter.date(from: date)
                    formatter.dateFormat = "EEEE, MMM d, yyyy"
                    let dateString = formatter.string(from: dateDate!)
                    post.date = dateString
                }
                post.imgURL = "https://image.ibb.co/eFh2WK/no_image_placeholder_big_300x200.jpg"
                if let better_featured_image = item["better_featured_image"] as? [String: AnyObject] {
                    if let source_url = better_featured_image["source_url"] as? String{
                        post.imgURL = source_url
                    }
                    if let media_details = better_featured_image["media_details"] as? [String: AnyObject] {
                        if let sizes = media_details["sizes"] as? [String: AnyObject] {
                            if let large = sizes["large"] as? [String: AnyObject] {
                                if let image = large["source_url"] as? String {
                                    post.imgURL = image
                                }
                            }else{
                                if let medium = sizes["medium_large"] as? [String: AnyObject] {
                                    if let image = medium["source_url"] as? String {
                                        post.imgURL = image
                                    }
                                }
                            }
                        }
                    }
                }
                    
                if let link_json = item["guid"] as? [String: AnyObject] {
                    if let link = link_json["rendered"] as? String {
                        post.postURL = link
                    }
                }
                self.downloadedPosts.append(post)
            }
            DispatchQueue.main.async(execute: {
                if self.page == 1 && self.posts.count != 0{
                    if self.posts[0].title == self.downloadedPosts[0].title {
                        self.refreshController.endRefreshing()
                        AudioServicesPlaySystemSound(1519)
                    }
                    else{
                        self.posts = self.downloadedPosts
                        self.tableView.reloadData()
                        self.fetchData = false
                        self.refreshController.endRefreshing()
                        self.saveData(data: self.posts, filePath: savedPostsFilePath)
                        FloatingMessage().floatingMessage(Message: "New Posts", onPresentation: {
                            self.refreshController.endRefreshing()
                            AudioServicesPlaySystemSound(1519)
                        }, onDismiss: {
                            return
                        })
                        print("reloading table view with new set of data")
                    }
                }else{
                    self.posts = self.downloadedPosts
                    self.fetchData = false
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                    self.saveData(data: self.posts, filePath: savedPostsFilePath)
                }
            })
        }
    }
    
    @objc func clearCache() {
        self.posts = []
        tableView.reloadData()
        saveData(data: self.posts, filePath: savedPostsFilePath)
        refreshData()
    }
}

//MARK:- Theming Protocols

extension WordpressFeedViewController: Themed {
    
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.separatorColor
        refreshController.tintColor = theme.titleTextColor
        refreshController.reloadInputViews()
    }
}

//MARK:- TableView Protocols

extension WordpressFeedViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == posts.count  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WordpressFeedLoaderViewCellId", for: indexPath) as! WordpressFeedLoaderViewCell
            cell.loaderView.startAnimating()
            if fail{
                cell.loaderTextLabel.isHidden = false
                cell.loaderView.isHidden = true
                self.fail = false
            }else{
                cell.loaderTextLabel.isHidden = true
                cell.loaderView.isHidden = false
            }
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordpressFeedTableViewCellId", for: indexPath) as! WordpressFeedTableViewCell
        cell.postTitle.text = posts[indexPath.row].title
        if let imgURL = posts[indexPath.row].imgURL {
            let url = NSURL(string: imgURL)
            cell.postImage.sd_setImage(with: url! as URL, placeholderImage:nil)
        }
        cell.dateLabel.text = posts[indexPath.row].date
//        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == posts.count{
            return view.frame.height/8
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordpressFeedPostViewController = WordpressFeedPostViewController()
        wordpressFeedPostViewController.post = posts[indexPath.row]
        wordpressFeedPostViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(wordpressFeedPostViewController, animated: true)
    }
    
}

//MARK:- 3D Touch Protocols

extension WordpressFeedViewController: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                return nil
        }
        let postVC = WordpressFeedPostViewController()
        postVC.hidesBottomBarWhenPushed = true
        postVC.post = posts[indexPath.row]
        previewingContext.sourceRect = cell.frame
        return postVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
