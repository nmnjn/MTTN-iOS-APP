//
//  SettingsViewController.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import SafariServices
import UserNotifications


class SettingsViewController: UIViewController{
    
    fileprivate let cellId = "cellId"
    
    var aboutInfoHeader: AboutInfoHeader?
    var wordpressFeedViewController: WordpressFeedViewController?
    
    let developerView = DeveloperView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 92)
        aboutInfoHeader = AboutInfoHeader(frame: frame)
        aboutInfoHeader?.settingsViewController = self
        tableView.tableHeaderView = aboutInfoHeader
        tableView.tableFooterView = UIView()
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
            
        }
    }
    
    fileprivate func setupTableView(){
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    fileprivate func setupNavigationBar(){
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func showDeveloper() {
        developerView.settingsViewController = self
        developerView.showMenu()
    }
    
    func sendMailTo(email: String){
        if let url = URL(string: "mailto:\(email)"){
            UIApplication.shared.open(url)
        }
    }
    
    func switchAppIcon(){
        if UserDefaults.standard.bool(forKey: "darkIcon"){
            AppIconService().changeAppIcon(to: AppIconService.AppIcon.PrimaryAppIcon)
            UserDefaults.standard.set(false, forKey: "darkIcon")
            UserDefaults.standard.synchronize()
        }else{
            AppIconService().changeAppIcon(to: AppIconService.AppIcon.DarkAppIcon )
            UserDefaults.standard.set(true, forKey: "darkIcon")
            UserDefaults.standard.synchronize()
        }
    }
    
    func openInstagram(username: String){
        let appURL = NSURL(string: "instagram://user?username=\(username)")!
        let webURL = NSURL(string: "https://instagram.com/\(username)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            openLink(link: "\(webURL)")
        }
    }
    
    func openYoutube(){
        let id = "UCwW9nPcEM2wGfsa06LTYlFg"
        let appURL = NSURL(string: "youtube://www.youtube.com/channel/\(id)")!
        let webURL = NSURL(string: "https://www.youtube.com/channel/\(id)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            openLink(link: "\(webURL)")
        }
    }
    
    func openFacebook(){
        let username =  "manipalthetalk"
        let appURL = URL(string: "fb://profile/\(167638709914049)")!
        let webURL = NSURL(string: "https://www.facebook.com/\(username)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            openLink(link: "\(webURL)")
        }
    }
    
    func openTwitter(){
        let username =  "manipalthetalk"
        let appURL = NSURL(string: "twitter://user?screen_name=\(username)")!
        let webURL = NSURL(string: "https://twitter.com/\(username)")!
        let application = UIApplication.shared
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            openLink(link: "\(webURL)")
        }
    }
    
    func requestReviewManually() {
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1386295566?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}


extension SettingsViewController: Themed{
    
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.backgroundColor
        tableView.reloadData()
        if UserDefaults.standard.darkModeEnabled{
            tableView.separatorColor = UIColor.init(white: 0.4, alpha: 0.3)
        }else{
            tableView.separatorColor = UIColor.init(white: 0.6, alpha: 0.3)
        }

    }
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsData.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.text = SettingsData(rawValue: section)?.description
        view.addSubview(title)
        _ = title.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
            title.textColor = .label
        }else{
            if UserDefaults.standard.darkModeEnabled{
                view.backgroundColor = UIColor.init(white: 0.1, alpha: 1)
                title.textColor = UIColor.init(white: 0.80, alpha: 1)
            }else{
                view.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
                title.textColor = UIColor.init(white: 0.20, alpha: 1)
            }
        }
        return view
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsData(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .Social:
            return SocialOptions.allCases.count
        case .Settings:
            if #available(iOS 13.0, *) {
                return SettingsOptions.allCases.count - 1
            } else {
                return SettingsOptions.allCases.count
            }
            
        case .Others:
            return OtherOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingsTableViewCell
        guard let section = SettingsData(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.settingsType = social
            cell.accessoryType = .disclosureIndicator
        case .Settings:
            guard let settings = SettingsOptions(rawValue: indexPath.row) else {return UITableViewCell()}
            cell.settingsType = settings
            switch settings{
            case .DarkMode:
                cell.selectionStyle = .none
                break
//            case .Notifications:
//                cell.selectionStyle = .none
//                break
            case .AppIcons:
                cell.accessoryType = .disclosureIndicator
                break
            }
        case .Others:
            let others = OtherOptions(rawValue: indexPath.row)
            cell.settingsType = others
            cell.accessoryType = .disclosureIndicator
        }
        if #available(iOS 13.0, *) {
            cell.textLabel?.textColor = .label
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsData(rawValue: indexPath.section) else{
            return
        }
        switch section {
        case .Social:
            guard let social = SocialOptions(rawValue: indexPath.row) else {return}
            switch social {
            case .Instagram:
                openInstagram(username: "manipalthetalk")
            case .Facebook:
                openFacebook()
            case .Twitter:
                openTwitter()
            case .Website:
                openLink(link: "https://manipalthetalk.org")
            case .Youtube:
                openYoutube()
            }
        case .Settings:
            guard let settings = SettingsOptions(rawValue: indexPath.row) else {return}
            switch settings{
            case .DarkMode:
                break
            case .AppIcons:
//                showAppIcons()
                switchAppIcon()
                break
            }
        case .Others:
            guard let others = OtherOptions(rawValue: indexPath.row) else {return}
            switch others{
            case .Developer:
                self.showDeveloper()
                break
            case .PrivacyPolicy:
                openLink(link: "https://termsfeed.com/privacy-policy/ec69fc0be140c10cf91cf70816a8ba79")
                break
//            case .SourceCode:
//                openLink(link: "https://github.com/naman17/MTTN-iOS-APP")
                
            case .Review:
                requestReviewManually()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showAppIcons(){
        let vc = AppIconsViewController()
        navigationController?.pushViewController(vc, animated: true)
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
