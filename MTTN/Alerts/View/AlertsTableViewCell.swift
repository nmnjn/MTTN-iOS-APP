//
//  AlertsTableViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 04/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class AlertsTableViewCell: UITableViewCell{
    
    lazy var backgroundCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        if #available(iOS 13.0, *) {
            backgroundCard.backgroundColor = .secondarySystemBackground
        } else {
            setupTheming()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        addSubview(backgroundCard)
        _ = backgroundCard.anchor(top: topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        addSubview(titleLabel)
        _ = titleLabel.anchor(top: backgroundCard.topAnchor, left: backgroundCard.leftAnchor, bottom: nil, right: backgroundCard.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        addSubview(bodyLabel)
        _ = bodyLabel.anchor(top: titleLabel.bottomAnchor, left: backgroundCard.leftAnchor, bottom: nil, right: backgroundCard.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        addSubview(dateLabel)
        _ = dateLabel.anchor(top: bodyLabel.bottomAnchor, left: backgroundCard.leftAnchor, bottom: backgroundCard.bottomAnchor, right: backgroundCard.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        addSubview(typeLabel)
        _ = typeLabel.anchor(top: bodyLabel.bottomAnchor, left: nil, bottom: backgroundCard.bottomAnchor, right: backgroundCard.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)

    }
    
}

extension AlertsTableViewCell: Themed{
    
    func applyTheme(_ theme: AppTheme) {
        backgroundCard.backgroundColor = theme.cardColor
        titleLabel.textColor = theme.titleTextColor
    }
}
