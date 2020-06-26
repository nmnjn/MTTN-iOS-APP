//
//  DirectoryTableViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class DirectoryTableViewCell: UITableViewCell{
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if UserDefaults.standard.darkModeEnabled {
            self.selectedBackgroundView!.backgroundColor = selected ? UIColor.init(white: 0.15, alpha: 1) : UIColor.init(white: 0.15, alpha: 1)
        }else{
            self.selectedBackgroundView!.backgroundColor = selected ? UIColor.init(white: 0.85, alpha: 1) : UIColor.init(white: 0.85, alpha: 1)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        if #available(iOS 13.0, *) {
            textLabel?.textColor = .label
            detailTextLabel?.textColor = .secondaryLabel
        } else {
            setupTheming()
            self.selectedBackgroundView = UIView()
        }
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DirectoryTableViewCell: Themed{
    func applyTheme(_ theme: AppTheme) {
        textLabel?.textColor = theme.titleTextColor
        detailTextLabel?.textColor = theme.detailedTextColor
    }
}
