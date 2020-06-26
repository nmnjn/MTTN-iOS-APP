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

class AlertsViewController: UITableViewController{
    var alerts = [Alert]()
    var ref: DatabaseReference?
    
    fileprivate let alertCellId = "alertCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationController()
        
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
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self, sourceView: tableView)
        }
    }
    
    @objc func alertsFetch() {
        ref = Database.database().reference()
        ref?.child("Alerts").observe(.childAdded, with: { (snapshot) in
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
            self.alerts.insert(alert, at: 0)
            self.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: UITableView.RowAnimation.fade)
        })
        
        ref?.child("Alerts").observe(.childChanged, with: { (snapshot) in
            for x in 0..<self.alerts.count{
                if self.alerts[x].key == snapshot.key{
                    if let newBody = snapshot.childSnapshot(forPath: "Body").value as? String{
                        self.alerts[x].message = newBody
                    }
                    if let newHead = snapshot.childSnapshot(forPath: "Head").value as? String{
                        self.alerts[x].title = newHead
                    }
                    if let newUrl = snapshot.childSnapshot(forPath: "Url").value as? String{
                        self.alerts[x].url = newUrl
                    }
                    if let newDate = snapshot.childSnapshot(forPath: "Date").value as? String{
                        self.alerts[x].date = newDate
                    }
                    self.tableView.reloadRows(at: [IndexPath(item: x, section: 0)], with: .automatic)
                    break
                }
            }
        })
        
        ref?.child("Alerts").observe(.childRemoved, with: { (snapshot) in
                for x in 0..<self.alerts.count{
                    if self.alerts[x].key == snapshot.key{
                        self.alerts.remove(at: x)
                        self.tableView.deleteRows(at: [IndexPath(item: x, section: 0)], with: UITableView.RowAnimation.fade)
                        break
                    }
                }
        })
        
        
    }
    
    fileprivate func setupNavigationController(){
        navigationItem.title = "Alerts"
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: alertCellId, for: indexPath) as! AlertsTableViewCell
        cell.selectionStyle  = .none
        cell.bodyLabel.text = alerts[indexPath.row].message
        cell.titleLabel.text = alerts[indexPath.row].title
        cell.dateLabel.text = alerts[indexPath.row].date
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
