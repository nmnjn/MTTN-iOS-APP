//
//  InstagramData.swift
//  MTTN
//
//  Created by Naman Jain on 31/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

struct InstagramResponse: Codable{
    let data: [InstagramData]
}

struct InstagramData: Codable{
    let media_url: String
    let permalink: String
    let thumbnail_url: String?
    let media_type: String
}
