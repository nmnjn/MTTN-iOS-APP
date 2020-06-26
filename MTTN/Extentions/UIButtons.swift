//
//  UIButtons.swift
//  MTTN
//
//  Created by Naman Jain on 15/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

extension UIButton {
    func dropShadowButton(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
