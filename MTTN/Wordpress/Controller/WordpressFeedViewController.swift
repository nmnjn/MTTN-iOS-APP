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
import DropDown

class WordpressFeedViewController: UIViewController, UISearchBarDelegate {
    var tableView = UITableView()
    var posts = [postDetails]()
    var downloadedPosts = [postDetails]()
    var page = 1
    var fetchData = false
    var fail = false
    var refreshController = UIRefreshControl()
	let blurView = UIVisualEffectView()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    var isSearching = false
    var searched = false
    
    let cellId = "cellId"
    
    let dropDown = DropDown()
    
    var button = UIButton()
    

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
	
	lazy var dropDownButton : UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "category"), for: .normal)
		button.addTarget(self, action:#selector(showMenu) , for: .touchUpInside)
		return button
	}()
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
		view.addSubview(dropDownButton)
        setupNavigationBar()
        setupTableView()
        setupSearchBar()
		setupDropDown()
        if #available(iOS 13.0, *) {
        } else {
            setupTheming()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshController.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.viewWithTag(9)?.removeFromSuperview()
    }
    
	fileprivate func setupDropDown(){
		
		dropDownButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 8))
		let dropDownId = ["","2389","2401","2390","2391","2393","2394","2392","2403","2405","2406","2404","2383","2385","2402","2386","2384","2387","2388","2400","2396","2398","2397","2399"]

		dropDown.anchorView = view// UIView or UIBarButtonItem
		dropDown.dataSource = ["MTTN Feed", "Creative", "Creative Extras", "Poetry","Stories","Current Affairs","Cognizant Citizen","Entertainment","Informative","General","Interviews","Science and Tech","Manipal","Clubs","Events","Fests","Fresher's Guide","In and Around Manipal","Seniors Guide","Miscellaneous","Rights","LGBTQ+","Women's Rights","Others"]
		dropDown.width = view.frame.width - 96

		// fix this
		dropDown.bottomOffset = CGPoint(x: 48, y: 145)
        dropDown.cornerRadius = 10
        dropDown.backgroundColor = UIColor.init(named: "DropDownColor")
        dropDown.textColor = UIColor.init(named: "DropDownTextColor") ?? .white
        dropDown.textFont = UIFont.boldSystemFont(ofSize: 15)
//        dropDown.selectionBackgroundColor = .clear
        dropDown.direction = .bottom
        
		
		dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
			let id = dropDownId[index]
				feedURL = "https://www.manipalthetalk.org/wp-json/wp/v2/posts?categories=\(id)&page="
				DispatchQueue.main.async(execute: {
					searched = true
					clearCache()
					view.viewWithTag(9)?.removeFromSuperview()
					dropDownButton.isHidden = false
//                    dropDown.selectionBackgroundColor = UIColor.clear
				})
			navigationItem.title = dropDown.dataSource[index]
		  print("Selected item: \(item) at index: \(index)")
		}
		
		dropDown.cancelAction = { [unowned self] in
			dropDownButton.isHidden = false
			view.viewWithTag(9)?.removeFromSuperview()
			print("Drop down dismissed")
//            dropDown.selectionBackgroundColor = UIColor.clear
		}
	}
    

    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Feed"
		searchController.searchBar.searchBarStyle = .minimal
		searchController.searchBar.sizeToFit()
    }

    fileprivate func setupNavigationBar() {

        navigationItem.title = "MTTN Feed"
		
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(handleInfoButtonTapped), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
//		let menuButton = UIButton(type: .infoLight)
//		menuButton.setImage(UIImage(named: "chevron-down"), for: .normal)
//        menuButton.addTarget(self, action:#selector(showMenu) , for: .touchUpInside)
//        let menuBarButtonItem = UIBarButtonItem(customView: menuButton)
//        navigationItem.leftBarButtonItem = menuBarButtonItem
    }
    
    @objc func showMenu(){
	    dropDownButton.isHidden = true
        dropDown.show()
		showBlurView()
    }
	
	fileprivate func showBlurView(){
		view.addSubview(blurView)
		blurView.fillSuperview()
		blurView.tag = 9
		let blurEffect = UIBlurEffect(style: .dark)
		blurView.effect = blurEffect
	}

    @objc fileprivate func handleInfoButtonTapped(){
        let settingsViewController = SettingsViewController()
        settingsViewController.wordpressFeedViewController = self
        settingsViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    fileprivate func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(WordpressFeedTableViewCell.self, forCellReuseIdentifier: "WordpressFeedTableViewCellId")
        tableView.register(WordpressFeedLoaderViewCell.self, forCellReuseIdentifier: "WordpressFeedLoaderViewCellId")

        refreshController.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshController
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 295
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.fillSuperview()

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
        var config = SwiftMessages.defaultConfig
        messageView.configureDropShadow()
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .color(color: UIColor(white: 0, alpha: 0.55), interactive: true)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            print(self.isSearching)
            DispatchQueue.main.async(execute: {
                if self.isSearching == false {
                    self.refreshController.beginRefreshing()
                }
                self.getPosts()
            })
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
        print(feedURL + "\(page)")
        self.isSearching = false
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
            print(items.count)
            if items.count == 0 {
                DispatchQueue.main.async {
                    FloatingMessage().floatingMessage(Message: "No posts found", onPresentation: {
                        self.refreshController.endRefreshing()
                    }, onDismiss: {
                        return
                    })
                }
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
				print(post.imgURL)
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
    
    func categorySearch(id : String){
        if id == "0" {
            feedURL = "https://www.manipalthetalk.org/wp-json/wp/v2/posts?page="
        }
        else{
            feedURL = "https://www.manipalthetalk.org/wp-json/wp/v2/posts?categories=\(id)&page="
        }
        DispatchQueue.main.async(execute: {
            self.searched = true
            self.clearCache()
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        feedURL = "https://www.manipalthetalk.org/wp-json/wp/v2/posts?page="
        self.isSearching = false
		self.dropDownButton.isHidden = false
        if self.searched == false {
            return
        }
        DispatchQueue.main.async(execute: {
            //self.refreshControl?.endRefreshing()
            self.searched = false
            self.clearCache()
        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.isSearching = true
		self.dropDownButton.isHidden = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            if searchText == "" {
                return
            }
            feedURL = "https://www.manipalthetalk.org/wp-json/wp/v2/posts?search=\(searchText)&page="
            DispatchQueue.main.async(execute: {
                self.searched = true
                self.clearCache()
            })
        })
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
        print("color" , theme.backgroundColor)
        refreshController.tintColor = theme.titleTextColor
        refreshController.reloadInputViews()
    }
}

//MARK:- TableView Protocols

extension WordpressFeedViewController : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            var url = NSURL(string: imgURL)
            if(url == nil){
                url = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/mttn-475ad.appspot.com/o/default-image.jpeg?alt=media&token=0e70c765-790a-402d-a165-d6fba0093667")
            }
            cell.postImage.sd_setImage(with: url! as URL, placeholderImage:nil)
        }
        cell.dateLabel.text = posts[indexPath.row].date
//        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == posts.count{
            return view.frame.height/8
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

