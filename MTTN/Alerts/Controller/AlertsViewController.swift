//
//  AlertsViewController.swift
//  MTTN
//
//  Created by Naman Jain on 04/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import AudioToolbox
import DropDown

class AlertsViewController: UITableViewController{
    var alerts = [Alert]()
    var filteredAlerts = [Alert]()
    var ref: DatabaseReference?
    var isFiltering: Bool = false
    let dropDown = DropDown()
    let filteredArrays = ["ALL", "MIT", "DOC", "MIC", "MSAP", "MCH"]
    
    var type : String = ""
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .lightGray
        label.text = "No Data Available"
        return label
    }()
    
    
    
    fileprivate let alertCellId = "alertCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if #available(iOS 13.0, *) {
            setupNavigationController()
        } else {
            // Fallback on earlier versions
        }
        
        type = UserDefaults.standard.string(forKey: "Type") ?? ""
        print(type)
        
        if #available(iOS 13.0, *) {
            
        }else{
            setupTheming()
        }
        alertsFetch()
    }
    
    fileprivate func setupTableView(){
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AlertsTableViewCell.self, forCellReuseIdentifier: alertCellId)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    
    @objc func alertsFetch() {
        ref = Database.database().reference()
        ref?.child("Notices").observe(.childAdded, with: { (snapshot) in
            var alert = Alert()
            alert.key = snapshot.key
            let title = snapshot.childSnapshot(forPath: "Head").value as? String
            if let actualTitle = title {
                alert.title = actualTitle
            }
            let message = snapshot.childSnapshot(forPath: "Body").value as? String
            if let actualMessage = message {
                alert.message = actualMessage
            }
            let date = snapshot.childSnapshot(forPath: "Date").value as? String
            if let actualDate = date{
                alert.date = actualDate
            }
            let url = snapshot.childSnapshot(forPath: "Url").value as? String
            if let actualUrl = url{
                alert.url = actualUrl
            }
            let type = snapshot.childSnapshot(forPath: "Type").value as? String
            if let actualType = type{
                alert.type = actualType
            }
            if self.type != "" {
                if let actualType = type {
                    if self.type == actualType {
                        self.alerts.insert(alert, at: 0)
                        self.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: UITableView.RowAnimation.fade)
                    }
                }
            }
            else {
                self.alerts.insert(alert, at: 0)
                self.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: UITableView.RowAnimation.fade)
            }
        })
    }
    
    @available(iOS 13.0, *)
    fileprivate func setupNavigationController(){
        navigationItem.title = "Alerts"
        navigationController?.navigationBar.prefersLargeTitles = true
		
		let button = UIButton(type: .infoLight)
		button.setImage(UIImage(named: "chevron-down"), for: .normal)
		button.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        let dropDownButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(handleFilterButton))
		navigationItem.rightBarButtonItem = dropDownButtonItem
        
//        let button = UIBarButtonItem(image: UIImage.init(systemName: "chevron.down"), style: .done, target: self, action: #selector(handleFilterButton))
        dropDown.anchorView = dropDownButtonItem
		// stupid bug here 
        dropDown.dataSource = ["All","Manipal Institute of Technology","Department of Commerce","Manipal Institute of Communication","Manipal School of Architecture","Manipal Centre for Humanities","",""]
        setupDropDown()
    }
    
    @objc func handleFilterButton(){
        dropDown.show()
    }
    
    
    fileprivate func setupDropDown(){

        dropDown.cornerRadius = 10
		dropDown.backgroundColor = UIColor.init(named: "DropDownColor")
		dropDown.textColor = UIColor.init(named: "DropDownTextColor") ?? .white
        dropDown.textFont = UIFont.boldSystemFont(ofSize: 15)
//        dropDown.selectionBackgroundColor = UIColor.clear
        dropDown.bottomOffset = CGPoint(x: 0, y: 40)
        dropDown.width = 300
		dropDown.direction = .bottom
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            isFiltering = true
            if index == 0 {
                type = ""
                UserDefaults.standard.set("", forKey: "Type")
                refreshData()
            }
            else {
                let filterText = filteredArrays[index]
                UserDefaults.standard.set(filterText, forKey: "Type")
                print(filterText)
                filteredAlerts = dump(alerts.filter({$0.type == filterText}))
                tableView.reloadData()
            }
        }
    }
    
    @objc func refreshData() {
        isFiltering = false
        alerts = []
        alertsFetch()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering == true {
            return filteredAlerts.count
        }
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: alertCellId, for: indexPath) as! AlertsTableViewCell
        cell.selectionStyle  = .none
        if isFiltering == true {
            cell.bodyLabel.text = filteredAlerts[indexPath.row].message
            cell.titleLabel.text = filteredAlerts[indexPath.row].title
            cell.dateLabel.text = filteredAlerts[indexPath.row].date
            cell.typeLabel.text = filteredAlerts[indexPath.row].type
        }
        else {
            cell.bodyLabel.text = alerts[indexPath.row].message
            cell.titleLabel.text = alerts[indexPath.row].title
            cell.dateLabel.text = alerts[indexPath.row].date
            cell.typeLabel.text = alerts[indexPath.row].type
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering == true {
            if let url = filteredAlerts[indexPath.row].url{
                let URLString = URL(string: url)
                let svc = SFSafariViewController(url: URLString!)
                if UserDefaults.standard.darkModeEnabled{
                    svc.preferredBarTintColor = .black
                    svc.preferredControlTintColor = .white
                }
                present(svc, animated: true, completion: nil)
            }else{
                print("No URL TO BE SEEN HERE")
            }
            
        }
        else {
            if let url = alerts[indexPath.row].url{
                let URLString = URL(string: url)
                let svc = SFSafariViewController(url: URLString!)
                if UserDefaults.standard.darkModeEnabled{
                    svc.preferredBarTintColor = .black
                    svc.preferredControlTintColor = .white
                }
                present(svc, animated: true, completion: nil)
            }else{
                print("No URL TO BE SEEN HERE")
            }
        }
    }
}


extension AlertsViewController: Themed{
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.backgroundColor
    }
}


//MARK:- 3D Touch Protocols

extension AlertsViewController: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else {
                print("Error here")
                return nil
        }
        guard let url = alerts[indexPath.row].url else{
            print("Error herer")
            return nil
        }
        let URLString = URL(string: url)
        let svc = SFSafariViewController(url: URLString!)
        if UserDefaults.standard.darkModeEnabled{
            svc.preferredBarTintColor = .black
            svc.preferredControlTintColor = .white
        }
        previewingContext.sourceRect = cell.frame
        return svc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: true, completion: nil)
    }
    
}
