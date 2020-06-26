//
//  WordpressFeedLoaderCell.swift
//  MTTN
//
//  Created by Naman Jain on 12/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation
import UIKit

class WordpressFeedLoaderViewCell: UITableViewCell{
    
    lazy var loaderTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Pull to Refresh"
        return label
    }()
    
    lazy var loaderView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        if #available(iOS 13.0, *) {
            loaderTextLabel.textColor = .tertiaryLabel
        }else{
            setupTheming()
        }
        
        addSubview(loaderView)
        addSubview(loaderTextLabel)

        loaderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loaderView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loaderView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        loaderTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loaderTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loaderTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        loaderTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WordpressFeedLoaderViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.backgroundColor
        loaderView.color = theme.titleTextColor
        loaderTextLabel.textColor = theme.titleTextColor
    }
}
