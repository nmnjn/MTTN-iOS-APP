//
//  SisAttendanceTableViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 21/12/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//


import UIKit
import Pastel

class SisAttendanceTableViewCell: UITableViewCell {
    
    let viewController = UIViewController()

    var percArray = [String]()
    var attdArray = [String]()
    var heldArray = [String]()
    var sectionNames = [String]()
    
    var attendance: SISattendance?{
        didSet{
            guard let attendance = attendance else { return }
//            print(attendance)
            sectionNames = []
            attdArray = []
            heldArray = []
            percArray = []
            if attendance.clinicsPerc != nil{
                sectionNames.append("Clinics")
                percArray.append(attendance.clinicsPerc!)
                attdArray.append(attendance.clinicsAttd ?? "")
                heldArray.append(attendance.clinicsHeld ?? "")
            }
            if attendance.theoryPerc != nil{
                 sectionNames.append("Theory")
                percArray.append(attendance.theoryPerc!)
                attdArray.append(attendance.theoryAttd ?? "")
                heldArray.append(attendance.theoryHeld ?? "")

            }
            if attendance.sgtPerc != nil{
                 sectionNames.append("SGT")
                percArray.append(attendance.sgtPerc!)
                attdArray.append(attendance.sgtAttd ?? "")
                heldArray.append(attendance.sgtHeld ?? "")
            }
            if attendance.practicalPerc != nil{
                 sectionNames.append("Practical")
                percArray.append(attendance.practicalPerc!)
                attdArray.append(attendance.practicalAttd ?? "")
                heldArray.append(attendance.practicalHeld ?? "")
            }
            tableView.reloadData()
        }
    }
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0
        return imageView
    }()
    
    lazy var pastelView: PastelView = {
        let view = PastelView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        // Custom Direction
        view.startPastelPoint = .bottomLeft
        view.endPastelPoint = .topRight
        
        
        // Custom Duration
        view.animationDuration = 1.5
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 22)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 27)
        }
        
        return label
    }()
    lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 42)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 52)
        }
        
        return label
    }()
    
    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        if viewController.isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 13)
        }
        else{
            label.font = UIFont.systemFont(ofSize: 16)
        }
        return label
    }()
    
    lazy var moreInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        if viewController.isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 11)
        }
        else{
            label.font = UIFont.systemFont(ofSize: 11)
        }
        return label
    }()
    
    lazy var subjectMarksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 12)
        }
        return label
    }()
    
    lazy var marksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        if viewController.isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 22)
        }
        else{
            label.font = UIFont.boldSystemFont(ofSize: 28)
        }
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.clipsToBounds = true
        tv.layer.masksToBounds = true
        tv.register(RegisteredEventCell.self, forCellReuseIdentifier: "cellId")
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 10
        tv.allowsSelection = false
//        tv.estimatedRowHeight = 70
        return tv
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .clear
//        addSubview(backgroundImageView)
        addSubview(pastelView)
        addSubview(nameLabel)
        addSubview(tableView)
        
        _ = pastelView.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = nameLabel.anchor(top: pastelView.topAnchor, left: pastelView.leftAnchor, bottom: nil, right: pastelView.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        _ = tableView.anchor(top: nameLabel.bottomAnchor, left: pastelView.leftAnchor, bottom: bottomAnchor, right: pastelView.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 24, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}



extension SisAttendanceTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! RegisteredEventCell
        
        cell.selectionStyle = .none
        cell.name.text = sectionNames[indexPath.row]
        cell.percentage.text = percArray[indexPath.row]
        cell.message.text = "ATTENDED \(attdArray[indexPath.row])\nOUT OF \(heldArray[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


class RegisteredEventCell: UITableViewCell{
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var percentage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    lazy var message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }
    
    func setupViews(){
        
        addSubview(percentage)
        _ = percentage.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        addSubview(message)
        _ = message.anchor(top: percentage.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        addSubview(name)
        name.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        addSubview(seperatorLine)
        _ = seperatorLine.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 64, bottomConstant: 0, rightConstant: 64, widthConstant: 0, heightConstant: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
