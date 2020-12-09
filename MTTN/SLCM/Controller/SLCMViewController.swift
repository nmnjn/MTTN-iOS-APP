//
//  SLCMViewController.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftMessages
import FirebaseDatabase

class SLCMViewController: UITableViewController{
    
    var refreshController = UIRefreshControl()
    var semesterSelectorBarButtonItem = UIBarButtonItem()
    var calculateGpaBarButtonItem = UIBarButtonItem()
    
    var attendance = [Attendance]()
    var sisAttendance = [SISattendance]()
    var credits =  [Credits]()
    var sisAllSemestersAttendance : [String: [SISattendance]]?{
        didSet{
            guard let allAttendance = sisAllSemestersAttendance else { return }
            var highestSem = ""
            for semester in allAttendance{
                if semester.key > highestSem {
                    highestSem = semester.key
                }
            }
            if highestSem == ""{
                return
            }else{
                DispatchQueue.main.async {
                    self.navigationItem.leftBarButtonItem?.title = "Semester \(highestSem)"
                    self.sisAttendance = allAttendance[highestSem]!
                    self.reload()
                }
            }
        }
    }
    var marks : [String: [String: MarksContainer]]?
    var noAttendance = true
    
    var arrayOfColors = [UIColor]()
    
    var darkArray = [UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
    UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0),
    UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
    UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0),
    UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
    UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
    UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
    UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1.0)]
    
    var lightArray = [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
    UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
    UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
    UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
    UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
    UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
    UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)]
    
    let slcmSettingsViewController = SLCMSettingsViewController()
    var isRefreshing = false

    fileprivate let attendanceCellId = "attendanceCellId"
    fileprivate let slcmCellId = "slcmCellId"
    fileprivate let sisAttendanceCellId = "sisAttendanceCellId"

    var isSis = false
    
    var ref : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isSis = UserDefaults.standard.bool(forKey: "isSis")
//        Networking.sharedInstance.fetchSISData()
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                    arrayOfColors = darkArray
                }else{
                    arrayOfColors = lightArray
                }
            
        } else {
            setupTheming()
        }
        
        setupNavigationBar()
        setupTableView()
        print("Loaded")
        if UserDefaults.standard.isLoggedIn(){
            
            if isSis{
                self.refreshData()
            }
            activateSLCMInterface()
            getData()
            reload()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.refreshController.beginRefreshing()
                self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-(self.refreshController.frame.size.height)), animated: false)
            }
        }
        else {
            DispatchQueue.main.async(execute: {
                let loginController = LoginViewController()
                loginController.slcmViewController = self
                loginController.modalPresentationStyle = .overFullScreen
                self.present(loginController, animated: true, completion: nil)
            })
        }
    }
    
    var fetchingAttendanceMessageID = "0"
    
    func showFetchingMessage(){
        let messageView: MessageView = MessageView.viewFromNib(layout: .statusLine)
        messageView.configureContent(title: "", body: "Fetching Attendance")
        messageView.button?.isHidden = true
        self.fetchingAttendanceMessageID = messageView.id
        var config = SwiftMessages.defaultConfig
        messageView.configureTheme(.success, iconStyle: .light)
        messageView.configureDropShadow()
        messageView.accessibilityPrefix = "warning"
        config.presentationStyle = .top
        config.duration = .seconds(seconds: 2)
        config.presentationContext  = .window(windowLevel: .normal)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    @objc func hideNotWorking(){
        SwiftMessages.hide(id: warningMessageId)
        let messageView: MessageView = MessageView.viewFromNib(layout: .tabView)
        messageView.configureContent(title: "We are connected with SLCM.", body: "Fetching latest data.")
        messageView.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        messageView.configureTheme(.success, iconStyle: .light)
        messageView.configureDropShadow()
        config.presentationStyle = .top
        config.duration = .seconds(seconds: 1)
        config.presentationContext  = .automatic
        SwiftMessages.show(config: config, view: messageView)
        self.refreshData()
    }
    
    var warningMessageId = "0"
    
    var isSLCMWorking = true
    
    @objc func showNotWorking(){
        
        let messageView: MessageView = MessageView.viewFromNib(layout: .tabView)
        
        if let date = UserDefaults.standard.object(forKey: "lastFetchedSLCM") as? Date{
            messageView.configureContent(title: "Unable to connect with SLcM.", body: "Your data was last updated \(date.day()!) at \(date.timeOfDay()!)")
        }else{
            messageView.configureContent(title: "Oh No!", body: "We are facing problems connecting to SLcM.")
        }

        messageView.button?.isHidden = true
        self.warningMessageId = messageView.id
        var config = SwiftMessages.defaultConfig
        messageView.configureTheme(.error, iconStyle: .light)
        messageView.iconImageView?.isHidden = true
        messageView.iconLabel?.isHidden = true
        messageView.configureDropShadow()
        messageView.accessibilityPrefix = "warning"
        config.presentationStyle = .top
        config.duration = .forever
        config.presentationContext  = .automatic
        SwiftMessages.show(config: config, view: messageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this is used to fix the app crashing issue caused due to lose in keychain
        if UserDefaults.standard.bool(forKey: "userHasUpdatedApp"){
            reloadTableView()
        }else{
            handleLogout()
            UserDefaults.standard.set(true, forKey: "userHasUpdatedApp")
        }
    }
    
    fileprivate func reloadTableView(){
        var indexPaths = [IndexPath]()
        if isSis{
            if self.sisAttendance.count == 0{
                let indexPath = IndexPath(row: 0, section: 0)
                indexPaths.append(indexPath)
            }else{
                for row in 0..<self.sisAttendance.count{
                    let indexPath = IndexPath(row: row, section: 0)
                    indexPaths.append(indexPath)
                }
            }
        }else{
            if self.attendance.count == 0{
                let indexPath = IndexPath(row: 0, section: 0)
                indexPaths.append(indexPath)
            }else{
                for row in 0..<self.attendance.count{
                    let indexPath = IndexPath(row: row, section: 0)
                    indexPaths.append(indexPath)
                }
            }
        }
        
        self.reload(indexPaths: indexPaths)
    }
    
    func setupNavigationBar(){
        if UserDefaults.standard.isLoggedIn(){
            if isSis{
                self.semesterSelectorBarButtonItem = UIBarButtonItem(title: "Semester", style: .plain, target: self, action: #selector(showSemesterSelector))
                self.navigationItem.leftBarButtonItem = semesterSelectorBarButtonItem
               navigationItem.title = "SIS"
            }else{
                navigationItem.title = "SLCM"
            }
        }else{
            navigationItem.title = ""
        }
    }
    
    
    @objc func showSemesterSelector(){
        
        guard let allSems = self.sisAllSemestersAttendance else { return }
        let sortedAllSems = allSems.sorted(by: { $0.0 > $1.0 })
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Semester", preferredStyle: .actionSheet)
        
        for semester in sortedAllSems{
            let semesterAction = UIAlertAction(title: "Semester \(semester.key)", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
                DispatchQueue.main.async {
                    self.sisAttendance = semester.value
                    self.reload()
                    self.navigationItem.leftBarButtonItem?.title = "Semester \(semester.key)"
                }
            })
            optionMenu.addAction(semesterAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.barButtonItem = semesterSelectorBarButtonItem
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    fileprivate func setupTableView(){
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AttendanceTableViewCell.self, forCellReuseIdentifier: attendanceCellId)
        tableView.register(SLCMTableViewCell.self, forCellReuseIdentifier: slcmCellId)
        tableView.register(SisAttendanceTableViewCell.self, forCellReuseIdentifier: sisAttendanceCellId)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        tableView.showsVerticalScrollIndicator = false
    }

    static func demoCentered() {
        let messageView: MessageView = MessageView.viewFromNib(layout: .tabView)
//        messageView.configureContent(title: "Oh No!", body: "We are facing problems connecting to SLCM. Your attendance was last updated on 16th October 5:48 PM.", iconImage: nil, iconText: "🦄", buttonImage: nil, buttonTitle: "No Thanks") { _ in
//            SwiftMessages.hide()
//        }
        messageView.configureContent(title: "Oh No!", body: "We are facing problems connecting to SLCM. Your attendance was last updated on 16th October at 5:48 PM.")
        messageView.button?.isHidden = true
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        messageView.configureTheme(.warning, iconStyle: .light)
        messageView.configureDropShadow()
        messageView.accessibilityPrefix = "warning"
        config.presentationStyle = .bottom
        config.duration = .forever
//        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .automatic
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func activateSLCMInterface(){
        DispatchQueue.main.async {
            self.refreshController.addTarget(self, action: #selector(self.refreshData), for: UIControl.Event.valueChanged)
            self.tableView.refreshControl = self.refreshController
            self.tableView.isScrollEnabled = true
        }
        
        let infoButton = UIButton(type: .detailDisclosure)
        infoButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
        
    }
    
    fileprivate func fetchData(){
        if isRefreshing{
            return
        }else{
            isRefreshing = true
        }
        var parameters : [String: String]
        if UserDefaults.standard.isLoggedIn(){
            if let para = UserDefaults.standard.dictionary(forKey: "parameter"){
                parameters = para as! [String : String]
            }else{
                self.showFloatingError(Message: "Authorisation Failed")
                self.handleLogout()
                return
            }
        }else{
            self.showFloatingError(Message: "Authorisation Failed")
            self.handleLogout()
            return
        }
        if isSis{
            Networking.sharedInstance.fetchSISData(Parameters: parameters, dataCompletion: { (att) in
                if UserDefaults.standard.isLoggedIn(){
                    // sort att here if needed
                    self.isRefreshing = false
//                    self.reloadTableView()
                    self.noAttendance = false
                    self.sisAllSemestersAttendance = att
                    
//                    self.reload()
                    
                }else{
                    self.attendance = []
                    self.noAttendance = true
                    self.reload()
                    return
                }
            }) { (SLCMError) in
                self.isRefreshing = false
                switch SLCMError{
                case .noAttendanceData:
                    self.noAttendance = true
                    self.showFloatingError(Message: "No Attendance Data")
                    break
                case .userNotLoggedIn:
                    break
                case .cannotFindSLCMUrl:
                    self.showFloatingError(Message: "Internal Database Error")
                    break
                case .connectionToSLCMFailed:
                    self.showFloatingError(Message: "Connection To SIS Failed")
                    break
                case .incorrectUserPassword:
                    self.showFloatingError(Message: "Couldn't Log into SIS")
                    break
                case .userLoggedOutDuringFetch:
                    break
                case .internalServerError:
                    self.showFloatingError(Message: "Unable to Fetch Attendance")
                    break
                case .serverOffline:
                    self.showFloatingError(Message: "Internal Server Offline")
                }
            }
            
        }else{
            Networking.sharedInstance.fetchSLCMData(Parameters: parameters, dataCompletion: { [weak self] (att, marks , credits) in
                guard let self = self else { return }
                if UserDefaults.standard.isLoggedIn(){
                    // sort att here if needed
                    self.isRefreshing = false
                    self.attendance = att
                    self.marks = marks
                    self.credits = credits
                    self.noAttendance = false
                    self.reload()
                }else{
                    self.attendance = []
                    self.noAttendance = true
                    self.reload()
                    return
                }
            }) { (SLCMError) in
                self.isRefreshing = false
                switch SLCMError{
                case .noAttendanceData:
                    self.noAttendance = true
                    self.showFloatingError(Message: "No Attendance Data")
                    break
                case .userNotLoggedIn:
                    break
                case .cannotFindSLCMUrl:
                    self.showFloatingError(Message: "Internal Database Error")
                    break
                case .connectionToSLCMFailed:
                    self.showFloatingError(Message: "Connection To SLCM Failed")
                    break
                case .incorrectUserPassword:
                    self.showFloatingError(Message: "Couldn't Log into SLCM")
                    break
                case .userLoggedOutDuringFetch:
                    break
                case .internalServerError:
                    self.showFloatingError(Message: "Unable to Fetch Attendance")
                    break
                case .serverOffline:
                    self.showFloatingError(Message: "Internal Server Offline")
                }
            }
        }
    }
    
    func showFloatingError(Message: String){
        DispatchQueue.main.async {
            FloatingMessage().floatingMessage(Message: Message, onPresentation: {
                self.refreshController.endRefreshing()
            }, onDismiss: {
                return
            })
        }
    }
    
    @objc func refreshData() {
        if Network.isConnectedToNetwork() == true {
            if self.isSLCMWorking{
                AudioServicesPlaySystemSound(1519)
//                self.refreshController.beginRefreshing()
                DispatchQueue.main.async {
//                    self.fetchData()
    //                self.floatingMessage(Message: "Refreshing")
                    
                    if self.isSis{
                        self.fetchData()

                    }else{
                        self.refreshControl?.endRefreshing()
                    }
                }
            }else{
               print("SLCM IS FUCKED YO")
                self.showNotWorking()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.refreshController.endRefreshing()
                })
            }
        }else{
            self.showFloatingError(Message: "No Internet Connection")
        }
    }
    
    func presentAlertWith(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getData(){
        if isSis{
            if let attendance = Networking.sharedInstance.getSavedSisAttendanceFromCache(){
                self.sisAllSemestersAttendance = attendance
            }
        }else{
            if let retrievedData = NSKeyedUnarchiver.unarchiveObject(withFile: savedAttendanceFilePath) as? [Attendance]{
                print("getting saved data \(retrievedData.count)")
                self.attendance = retrievedData
            }
            self.marks = Networking.sharedInstance.getSavedMarksFromCache()
        }
    }
    
    func reload() {
        print(attendance.count)
        print(sisAttendance.count)
        DispatchQueue.main.async(execute: {
            self.tableView?.reloadData()
            self.tableView?.refreshControl?.endRefreshing()
        })
    }
    
    func reload(indexPaths: [IndexPath]) {
        DispatchQueue.main.async(execute: {
            self.refreshController.endRefreshing()
            UIView.performWithoutAnimation {
                self.tableView.reloadRows(at: indexPaths, with: .none)
            }
        })
    }
    
    @objc func showSettings(){
        slcmSettingsViewController.slcmViewController = self
        slcmSettingsViewController.showMenu()
    }
    
    @objc func handleLogout() {
        AudioServicesPlaySystemSound(1521)
        tableView.scrollsToTop = true
        self.attendance = []
        self.sisAttendance = []
        self.sisAllSemestersAttendance = [:]
        Networking.sharedInstance.saveSLCMData(Attendance: [])
        Networking.sharedInstance.saveSISData(Attendance: [:])
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
            let loginController = LoginViewController()
            loginController.slcmViewController = self
            loginController.modalPresentationStyle = .overFullScreen
            self.present(loginController, animated: true, completion: nil)
            self.reload()
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "", style: .plain, target: self, action: nil), animated: true)
            self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "", style: .plain, target: self, action: nil), animated: true)
            self.setupNavigationBar()
            self.tableView.refreshControl = nil
            self.tableView.isScrollEnabled = false
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 12.0, *) {
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            if userInterfaceStyle == .light{
                arrayOfColors = [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)]
            }else{
                arrayOfColors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0),
                UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
                UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0),
                UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
                UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                UIColor(red: 95/255, green: 95/255, blue: 95/255, alpha: 1.0)]
            }
        }
        reloadTableView()
    }
}

extension SLCMViewController: Themed{
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.backgroundColor
        refreshController.tintColor = theme.titleTextColor
        arrayOfColors = theme.gradientColors
    }
}

extension SLCMViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSis{
            if sisAttendance.count == 0 {
                return 1
            }
            else{
                return sisAttendance.count
            }
        }else{
            if attendance.count == 0 {
                return 1
            }
            else{
                return attendance.count
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSis{
            if sisAttendance.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: slcmCellId, for: indexPath) as! SLCMTableViewCell
                cell.selectionStyle = .none
                if UserDefaults.standard.isLoggedIn(){
                    let x = Int(arc4random_uniform(13))
                    if noAttendance{
                        cell.waitLabel.text = "No Attendance Data!\nPull to Refresh"
                    }else{
                        cell.waitLabel.text = "Please wait while we fetch your data, currently " + array[x]
                    }
                    
                }
                else {
                    cell.waitLabel.text = "Tap to Login"
                }
                cell.pastelView.startAnimation()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: sisAttendanceCellId, for: indexPath) as! SisAttendanceTableViewCell
            
            let subject = sisAttendance[indexPath.row]
            cell.nameLabel.text = subject.subjectName?.uppercased()
            cell.attendance = subject
            
            cell.selectionStyle = .none
            if indexPath.row % 2 == 0{
                cell.pastelView.setColors(arrayOfColors)
            }else{
                cell.pastelView.setColors(arrayOfColors.reversed())
            }
            cell.pastelView.startAnimation()
            
            return cell
            
        }else{
            if attendance.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: slcmCellId, for: indexPath) as! SLCMTableViewCell
                cell.selectionStyle = .none
                if UserDefaults.standard.isLoggedIn(){
                    let x = Int(arc4random_uniform(13))
                    if noAttendance{
                        cell.waitLabel.text = "No Attendance Data!\nPull to Refresh"
                    }else{
                        cell.waitLabel.text = "Please wait while we fetch your data, currently " + array[x]
                    }
                    
                }
                else {
                    cell.waitLabel.text = "Tap to Login"
                }
                cell.pastelView.startAnimation()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: attendanceCellId, for: indexPath) as! AttendanceTableViewCell
            
            let subject = attendance[indexPath.row]
            cell.nameLabel.text = subject.Name?.uppercased()
            
            if let missed = subject.Missed, let total = subject.Total, let attended = subject.Attended{
                if total == "0"{
                    cell.notesLabel.text = "The attendance has\nnot been uploaded"
                }else{
                    if missed  == "0" {
                        cell.notesLabel.text = "\(attended) attended\nout of \(total) total"
                    }
                    else{
                        cell.notesLabel.text = "\(attended) attended\n and \(missed) missed\nout of \(total) total"
                    }
                }
            }
            cell.selectionStyle = .none
            if indexPath.row % 2 == 0{
                cell.pastelView.setColors(arrayOfColors)
            }else{
                cell.pastelView.setColors(arrayOfColors.reversed())
            }
            cell.pastelView.startAnimation()
            
            guard let percentageText = subject.Percentage else {
                cell.percentageLabel.text = subject.Percentage
                return cell
            }
            let percentageArray = percentageText.split(separator: ".")
            cell.percentageLabel.text = String(percentageArray[0])
            
            if let subjectName = subject.Name{
                print(subjectName)
                if let marks = self.marks{
                    if let subjectMarks = marks[subjectName] {
                        var totalSum : Float =  0.0
                        var obtainedSum : Float =  0.0
                        for mark in subjectMarks{
                            if mark.key == "Total Marks"{
                                continue
                            }
                            let floatP1 = Float(mark.value.Obtained ?? "0")
                            let floatP2 = Float(mark.value.Total ?? "0")
                            totalSum = totalSum + floatP2!
                            obtainedSum = obtainedSum + floatP1!
                        }
                        let marksText = "\(obtainedSum)/\(totalSum)"
                        if marksText == "0.0/0.0"{
                            cell.subjectMarksLabel.text = ""
                            cell.marksLabel.text = ""
                            cell.moreInfoLabel.text = ""
                        }else{
                            cell.subjectMarksLabel.text = "Subject Marks"
                            cell.marksLabel.text = marksText
                            cell.moreInfoLabel.text = "Tap for more"
                        }
                    }else{
                        cell.subjectMarksLabel.text = ""
                        cell.marksLabel.text = ""
                        cell.moreInfoLabel.text = ""
                    }
                }else{
                    cell.subjectMarksLabel.text = ""
                    cell.marksLabel.text = ""
                    cell.moreInfoLabel.text = ""
                }
            }
            
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSis{
            if sisAttendance.count == 0{
                let tabBarHeight = self.tabBarController?.tabBar.intrinsicContentSize.height
                if let navBarHeight = self.navigationController?.navigationBar.intrinsicContentSize.height{
                    let height = view.frame.height - (UIApplication.shared.statusBarFrame.height + navBarHeight + tabBarHeight! + 12)
                    return height
                }
            }
            
//            if isSmalliPhone(){
//               return 250
//            }else{
//               return 300
//            }
            var height: CGFloat = 50
            let const: CGFloat = 110
            let attendance = self.sisAttendance[indexPath.row]
        
            if isSmalliPhone(){
                height = 30
                height = height + (attendance.subjectName!.height(withConstrainedWidth: view.frame.width-64, font: UIFont.boldSystemFont(ofSize: 22)))
            }
            else{
                height = height + (attendance.subjectName!.height(withConstrainedWidth: view.frame.width-128, font: UIFont.boldSystemFont(ofSize: 27)))
            }
            
            if attendance.clinicsPerc != nil{
                height = height + const
            }
            if attendance.theoryPerc != nil{
                height = height + const
            }
            if attendance.sgtPerc != nil{
                height = height + const
            }
            if attendance.practicalPerc != nil{
                height = height + const
            }
            return height
        }else{
            
            if attendance.count == 0{
                let tabBarHeight = self.tabBarController?.tabBar.intrinsicContentSize.height
                if let navBarHeight = self.navigationController?.navigationBar.intrinsicContentSize.height{
                    let height = view.frame.height - (UIApplication.shared.statusBarFrame.height + navBarHeight + tabBarHeight! + 12)
                    return height
                }
            }
            
            if isSmalliPhone(){
               return 250
            }else{
               return 300
            }
        }

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaults.standard.isLoggedIn(){
            if isSis{
                
            }else{
                if let subjectName = self.attendance[indexPath.row].Name{
                    if let marks = self.marks{
                        if let subjectMarks = marks[subjectName] {
                            if subjectMarks.count == 0 {
                                return
                            }
                                let destinationVC = MarksViewController()// make a reference to a destination view controller
                                destinationVC.navTitle = self.attendance[indexPath.row].Name ?? ""
                                destinationVC.marks = subjectMarks
                                let destinationNav = MasterNavigationBarController(rootViewController: destinationVC)
                                let segue = SwiftMessagesSegue(identifier: nil, source: self, destination: destinationNav)
                            segue.configure(layout: .bottomTab)
                            
                            segue.dimMode = .color(color: UIColor(white: 0, alpha: 0.55), interactive: true)
                            segue.messageView.configureDropShadow()
                            segue.messageView.backgroundHeight = view.frame.height / 2
                            AudioServicesPlaySystemSound(1519)
                            segue.perform()
                        }
                    }
                }
                return
            }
        }
        else {
            DispatchQueue.main.async(execute: {
                AudioServicesPlaySystemSound(1519)
                let loginController = LoginViewController()
                loginController.slcmViewController = self
                loginController.modalPresentationStyle = .overFullScreen
                self.present(loginController, animated: true, completion: nil)
            })
        }
    }
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func timeOfDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: self)
    }
    
    func dateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func day() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        if dateFormatter.string(from: self) == dateFormatter.string(from: Date()) {
            return "today"
        }else{
            return "on \(dateFormatter.string(from: self).capitalized)"
        }
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension UIAlertController {

    func isGpaValid(_ gpa: String) -> Bool {
        let doubleGpa = (gpa as NSString).doubleValue
        if doubleGpa > 0.0 && doubleGpa <= 10.0 {
            return true
        }
        return false
    }


    @objc func textDidChangeInLoginAlert() {
        guard let gpa = textFields?[0].text else { return }
        if isGpaValid(gpa) {
            actions.last?.isEnabled = true
        }
        else {
            actions.last?.isEnabled = false
        }
    }
}
