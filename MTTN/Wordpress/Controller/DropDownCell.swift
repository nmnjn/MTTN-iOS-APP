//
//  TableViewCell.swift
//  MTTN
//
//  Created by Tushar Tapadia on 14/11/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import DropDown

class MyCell: DropDownCell {

    @IBOutlet var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImageView.contentMode = .scaleAspectFit
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
