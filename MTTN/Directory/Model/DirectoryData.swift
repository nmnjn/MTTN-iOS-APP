//
//  DirectoryData.swift
//  MTTN
//
//  Created by Naman Jain on 04/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation

struct Directory {
    var section: String?
    var phones: [Phone]
    var isOpen: Bool
}

struct Phone {
    var name: String?
    var number: String?
}
