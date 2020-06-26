//
//  DirectoryViewController.swift
//  MTTN
//
//  Created by Naman Jain on 04/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Firebase
import AudioToolbox

class DirectoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate let cellId = "cellId"
    
    var directory = [Directory]()
    var filteredContacts = [Phone]()
    var allContacts = [Phone]()
    
    var ref: DatabaseReference?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(DirectoryTableViewCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
        }
        setupNavigationController()
        setupTableView()
        setupDirectoryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func refreshData() {
        directory = []
        setupDirectoryData()
    }
    
    fileprivate func setupNavigationController(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        navigationItem.title = "Directory"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Directory"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.sizeToFit()
        
        //need to find a proper fix for this as this can break with any iOS update.
        
        if UserDefaults.standard.darkModeEnabled{
            let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = .white
        }
        definesPresentationContext = true
    }
    
    private func setupDirectoryData() {
        ref = Database.database().reference()
        ref?.child("Directory").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.key
            var phones = [Phone]()
            for child in snapshot.children{
                var phone = Phone()
                let val = child as! DataSnapshot
                phone.name = val.key
                if let number = val.value {
                    phone.number = "\(number)"
                }
                phones.append(phone)
            }
            let dir = Directory(section: value, phones: phones, isOpen: false)
            self.directory.append(dir)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func combineContacts(){
        allContacts = []
        for i in 0..<directory.count{
            for j in 0..<directory[i].phones.count{
                allContacts.append(directory[i].phones[j])
            }
        }
    }
    
    fileprivate func setupTableView(){
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

extension DirectoryViewController{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isFiltering(){
            return 0
        }
        return 45
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            return 1
        }
        return directory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContacts.count
        }
        if !directory[section].isOpen{
            return 0
        }
        return directory[section].phones.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DirectoryTableViewCell
        let phone: [Phone]
        if isFiltering() {
            phone = filteredContacts
        }else {
            phone = directory[indexPath.section].phones
        }
        if let name = phone[indexPath.row].name {
            cell.textLabel?.text = name
        }
        if let number = phone[indexPath.row].number{
            cell.detailTextLabel?.text = number
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(1519)
        //        let phone = dir[indexPath.section].phones
        let phone: [Phone]
        if isFiltering() {
            phone = filteredContacts
        }else {
            phone = directory[indexPath.section].phones
        }
        if let number = phone[indexPath.row].number{
            UIApplication.shared.open(NSURL(string: "tel://\(number)")! as URL)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @objc func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @objc func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        combineContacts()
        filteredContacts = allContacts.filter({( contact : Phone) -> Bool in
            if let name = contact.name?.lowercased().contains(searchText.lowercased()){
                return name
            }else {
                return false
            }
        })
        tableView.reloadData()
    }
    
    @objc func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()

        let categoryLabel: UILabel = {
            let label = UILabel()
            label.text = directory[section].section
            if isSmalliPhone(){
                label.font = UIFont.systemFont(ofSize: 15)
            }
            else{
                label.font = UIFont.systemFont(ofSize: 18)
            }
            return label
        }()
        
        let openCloseButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
            button.tag = section
            return button
        }()
        
        let separatorLine: UIView = {
            let view = UIView()
            return view
        }()
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            if let name = directory[section].section {
                iv.image = UIImage(named: name)
            }
            iv.clipsToBounds = true
            iv.contentMode = UIView.ContentMode.scaleAspectFit
            return iv
        }()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
            categoryLabel.textColor = UIColor(named: "directoryColor")
            separatorLine.backgroundColor = .quaternaryLabel
        } else {
            if UserDefaults.standard.darkModeEnabled{
                view.backgroundColor = .black
                categoryLabel.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                separatorLine.backgroundColor = UIColor.init(white: 0.4, alpha: 0.3)
            }else{
                view.backgroundColor = .white
                categoryLabel.textColor = self.view.tintColor
                separatorLine.backgroundColor = UIColor.init(white: 0.6, alpha: 0.3)
            }
        }
        view.addSubview(categoryLabel)
        view.addSubview(openCloseButton)
        view.addSubview(separatorLine)
        view.addSubview(imageView)
        openCloseButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        if isSmalliPhone(){
            _ = imageView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 18, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 0)
        }
        else{
            _ = imageView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 18, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 0)
        }
        _ = categoryLabel.anchor(top: view.topAnchor, left: imageView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 18, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = separatorLine.anchor(top: nil, left: imageView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 18, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.6)
        return view
    }
    
    @objc func handleOpenClose(button: UIButton){
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in 0..<directory[section].phones.count{
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isOpen = directory[section].isOpen
        directory[section].isOpen = !isOpen
        if !isOpen{
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        
    }
}

extension DirectoryViewController: Themed {
    func applyTheme(_ theme: AppTheme) {
        
        setNeedsStatusBarAppearanceUpdate()
        tableView.backgroundColor = theme.backgroundColor
        searchController.searchBar.tintColor = theme.appTintColor
        tableView.separatorColor = theme.separatorColor
        
        if UserDefaults.standard.darkModeEnabled{
            searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
            let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
            searchController.searchBar.barStyle = UIBarStyle.black
            textFieldInsideSearchBar?.textColor = .white
        }else{
            searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.light
            let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = .black
        }
    }
}

extension DirectoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
