//
//  UIImage.swift
//  MTTN
//
//  Created by Naman Jain on 23/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

extension UIImage {
    static func localImage(_ name: String, template: Bool = false) -> UIImage {
        var image = UIImage(named: name)!
        if template {
            image = image.withRenderingMode(.alwaysTemplate)
        }
        return image
    }
}
