//
//  YoutubeData.swift
//  MTTN
//
//  Created by Naman Jain on 31/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation


struct YouTubeResponse: Codable{
    let items: [YoutubeItem]
}
struct YoutubeItem: Codable{
    let id: YoutubeId
    let snippet: YoutubeSnippet
}

struct YoutubeId: Codable {
    let videoId: String?
    let playlistId: String?
}

struct YoutubeSnippet: Codable{
    let title: String
    let description: String
    let thumbnails: YoutubeThumbnails
}
struct YoutubeThumbnails: Codable{
    let high: YoutubeHighThumbnail
}
struct YoutubeHighThumbnail: Codable{
    let url: String
}
