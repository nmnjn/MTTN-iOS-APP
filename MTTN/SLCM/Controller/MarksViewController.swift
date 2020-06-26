//
//  MarksViewController.swift
//  MTTN
//
//  Created by Naman Jain on 25/10/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class MarksViewController: UITableViewController{
    
    var marks: [String: MarksContainer]?{
        didSet{
            guard let marks = marks else { return }
            let sortedMarks = marks.sorted { (m1, m2) -> Bool in
                    return m1.key < m2.key
                }
            for mark in sortedMarks{
                    if mark.key == "Total Marks"{
                        continue
                    }
                if mark.key.lowercased().contains("assignment"){
                    assignmentNames.append(mark.key)
                    assignmentMarks.append(mark.value.Obtained ?? "NA")
                    assignmentOutOfValues.append(mark.value.Total ?? "NA")
                }else if mark.key.lowercased().contains("sessional"){
                    sessionalNames.append(mark.key)
                    sessionalMarks.append(mark.value.Obtained ?? "NA")
                    sessionalOutOfValues.append(mark.value.Total ?? "NA")
                }else{
                    markNames.append(mark.key)
                    markValues.append(mark.value.Obtained ?? "NA")
                    outOfValues.append(mark.value.Total ?? "NA")
                }
            }
            
            tableView.reloadData()
        }
    }
    
    var assignmentNames = [String]()
    var assignmentMarks = [String]()
    var assignmentOutOfValues = [String]()
    
    var sessionalNames = [String]()
    var sessionalMarks = [String]()
    var sessionalOutOfValues = [String]()
    
    var markNames = [String]()
    var markValues = [String]()
    var outOfValues = [String]()
    
    var navTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
             
         } else {
             setupTheming()
             
         }
        
        navigationItem.title = self.navTitle
        tableView.register(MarksTableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    func setupTable(){
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return assignmentNames.count
        case 1: return sessionalNames.count
        case 2: return markNames.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! MarksTableViewCell
//        cell.textLabel?.text =  markNames[indexPath.row]
        switch indexPath.section{
        case 0:
            cell.nameLabel.text = assignmentNames[indexPath.row]
            cell.obtainedLabel.text = assignmentMarks[indexPath.row]
            cell.outOfLabel.text = "Out of \(assignmentOutOfValues[indexPath.row])"
            break
        case 1:
            cell.nameLabel.text = sessionalNames[indexPath.row]
            cell.obtainedLabel.text = sessionalMarks[indexPath.row]
            cell.outOfLabel.text = "Out of \(sessionalOutOfValues[indexPath.row])"
            break
        case 2:
            cell.nameLabel.text = markNames[indexPath.row]
            cell.obtainedLabel.text = markValues[indexPath.row]
            cell.outOfLabel.text = "Out of \(outOfValues[indexPath.row])"
        default: break
        }

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return assignmentNames.count == 0 ? 0 : 25
        case 2:
            return sessionalNames.count == 0 || markNames.count == 0 ? 0 : 25
        case 0:
            return 0
        default:
            return 25
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        let seperatorView = UIView()
        if #available(iOS 13.0, *) {
            seperatorView.backgroundColor = .quaternaryLabel
        } else {
            seperatorView.backgroundColor = .lightGray
        }
        
        view.addSubview(seperatorView)
        
        _ = seperatorView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 36, bottomConstant: 0, rightConstant: 36, widthConstant: 0, heightConstant: 1)
        
        return view
        
    }
}

extension MarksViewController: Themed{
    
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.backgroundColor
        tableView.reloadData()
    }
}

extension MarksTableViewCell: Themed{
        func applyTheme(_ theme: AppTheme) {
            nameLabel.textColor = theme.titleTextColor
            obtainedLabel.textColor = theme.titleTextColor
            outOfLabel.textColor = theme.titleTextColor
        }
    }


class MarksTableViewCell : UITableViewCell{
    
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let obtainedLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let outOfLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 13.0, *) {
             
         } else {
             setupTheming()
             
         }
        
        backgroundColor = .clear
        addSubview(obtainedLabel)
        addSubview(outOfLabel)
        addSubview(nameLabel)
        
        _ = obtainedLabel.anchor(top: nil, left: nil, bottom: outOfLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = outOfLabel.anchor(top: nil, left: nil, bottom: nameLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: -32, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        _ = nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 24, leftConstant: 16, bottomConstant: 8, rightConstant: 100, widthConstant: 0, heightConstant: 0)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
