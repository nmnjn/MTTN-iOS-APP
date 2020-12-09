//
//  PlaylistModel.swift
//  PlaylistFeatureforMTTN
//
//  Created by Tushar Tapadia on 03/10/20.
//  Copyright © 2020 Tushar Elangovan. All rights reserved.
//

import Foundation
//"_id": "5f82ed0c7576a800242cf754",
//"name": "Raindrops and Teacups",
//"link1": "https://open.spotify.com/playlist/1Ma51l1n8BBTLMY6DvMHew?si=7NPZ2kjRQru0QU7MfTKEOw",
//"link2": "https://music.apple.com/in/playlist/raindrops-and-teacups/pl.u-PDb4zlBFeDNBpNZ",
//"link3": "https://music.youtube.com/playlist?list=PLZec1Af5U9IdbC9q6G2nc8XM7xM206j5f",
//"description": "The gentle patter of rain against your window and the warmth that comes with a cup of tea. Here's a playlist for you to sink into.",
//"imgurl": "https://res.cloudinary.com/dg3afm8zd/image/upload/v1602415884/s3nsnetpmwonqn1e7lnr.jpg",
//"__v": 0

struct playlistData:Codable {
    let id:String?
    let name:String?
    let link1:String?
    let link2:String?
    let link3:String?
    let description:String?
    let imgurl:String?
}

