//
//  WordpressFeedData.swift
//  MTTN
//
//  Created by Naman Jain on 02/04/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation

var savedPostsFilePath: String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("SavedPostsNewNew").path
}
var staredPostsFilePath: String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("StaredPostsNew").path
}

let CSSStringLight = """
                <style media='screen' type='text/css'>
                *{font-family: sans-serif; font-size: 18px; line-height: 28px;}
                h1{font-size:1.5em; line-height: 35px;}
                h2{font-size:1.125em;}
                h3{font-size:1.05em;}
                h4,h5,h6{font-size:1em; margin:1em 0;}
                blockquote{font-style: italic;}
                figure{ max-width:100%; height:auto !important; width:95% !important; object-fit: contain; pointer-events: none !important; margin: 4px;}
                img,div{ max-width:100%; height:auto !important; width:100% !important; object-fit: contain; pointer-events: none;}
                figcaption{font-size: 14px; width:95% !important; margin: 4px;}
                img{border-radius: 10px !important;}</style>
"""

let CSSStringDark = """
                <style media='screen' type='text/css'>
                *{font-family: sans-serif; font-size: 18px; line-height: 28px; color: white;}
                h1{font-size:1.5em; line-height: 35px;}
                h2{font-size:1.125em;}
                h3{font-size:1.05em;}
                h4,h5,h6{font-size:1em; margin:1em 0;}
                blockquote{font-style: italic;}
                figure{ max-width:100%; height:auto !important; width:95% !important; object-fit: contain; pointer-events: none !important; margin: 4px;}
                img,div{ max-width:100%; height:auto !important; width:100% !important; object-fit: contain; pointer-events: none;}
                figcaption{font-size: 14px; width:95% !important; margin: 4px;}
                img{border-radius: 10px !important;}</style>
                """

let iOS13AdaptiveCSSString = """
                <style media='screen' type='text/css'>
                @media (prefers-color-scheme: dark) {
                    body {
                        background-color: rgb(0,0,0);
                        color: white;
                    }
                    a:link {
                        color: #0096e2;
                    }
                    a:visited {
                        color: #9d57df;
                    }
                }
                *{font-family: sans-serif; font-size: 18px; line-height: 28px;}
                h1{font-size:1.5em; line-height: 35px;}
                h2{font-size:1.125em;}
                h3{font-size:1.05em;}
                h4,h5,h6{font-size:1em; margin:1em 0;}
                blockquote{font-style: italic;}
                figure{ max-width:100%; height:auto !important; width:95% !important; object-fit: contain; pointer-events: none !important; margin: 4px;}
                img,div{ max-width:100%; height:auto !important; width:100% !important; object-fit: contain; pointer-events: none;}
                figcaption{font-size: 14px; width:95% !important; margin: 4px;}
                img{border-radius: 10px !important;}</style>
"""

let iOS13AdaptiveCSSStringDark = """
                <style media='screen' type='text/css'>
                @media (prefers-color-scheme: light) {
                    body {
                        background-color: rgb(1,1,1);
                        color: black;
                    }
                    a:link {
                        color: #0096e2;
                    }
                    a:visited {
                        color: #9d57df;
                    }
                }
                *{font-family: sans-serif; font-size: 18px; line-height: 28px; background-color: rgb(0,0,0);}
                h1{font-size:1.5em; line-height: 35px;}
                h2{font-size:1.125em;}
                h3{font-size:1.05em;}
                h4,h5,h6{font-size:1em; margin:1em 0;}
                blockquote{font-style: italic;}
                figure{ max-width:100%; height:auto !important; width:95% !important; object-fit: contain; pointer-events: none !important; margin: 4px;}
                img,div{ max-width:100%; height:auto !important; width:100% !important; object-fit: contain; pointer-events: none;}
                figcaption{font-size: 14px; width:95% !important; margin: 4px;}
                img{border-radius: 10px !important;}</style>
"""


class postDetails: NSObject, NSCoding {
    
    struct keys {
        static let title = "title"
        static let renderedContent = "renderedContent"
        static let date = "date"
        static let imgURL = "imgURL"
        static let postURL = "postURL"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: keys.title)
        aCoder.encode(renderedContent, forKey: keys.renderedContent)
        aCoder.encode(date, forKey: keys.date)
        aCoder.encode(imgURL, forKey: keys.imgURL)
        aCoder.encode(postURL, forKey: keys.postURL)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let att = aDecoder.decodeObject(forKey: keys.title) as? String{
            title = att
        }
        if let nam = aDecoder.decodeObject(forKey: keys.renderedContent) as? String{
            renderedContent = nam
        }
        if let per = aDecoder.decodeObject(forKey: keys.date) as? String{
            date = per
        }
        if let mis = aDecoder.decodeObject(forKey: keys.imgURL) as? String{
            imgURL = mis
        }
        if let tot = aDecoder.decodeObject(forKey: keys.postURL) as? String{
            postURL = tot
        }
    }
    
    @objc var title : String?
    @objc var renderedContent : String?
    @objc var date : String?
    @objc var imgURL : String?
    @objc var postURL : String?
    
    override init() {
    }
}
