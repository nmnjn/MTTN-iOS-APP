//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Naman Jain on 10/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent,
            let attURLStringDict = bestAttemptContent.userInfo["fcm_options"] as? [String: String],
            let attURLString = attURLStringDict["image"],
            let attURL = URL(string: attURLString) else {
                print("Failed to get Image Url")
                return
        }
        request.content.setValue("hello", forKey: "categoryIdentifier")
        
        print(request.content.categoryIdentifier)
        
        downloadImageFrom(url: attURL) { (attachment) in
            if let attachment = attachment {
                bestAttemptContent.attachments = [attachment]
                contentHandler(bestAttemptContent)
            }
        }
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func downloadImageFrom(url: URL, with completionHandler: @escaping (UNNotificationAttachment?) -> Void){
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else {
                completionHandler(nil)
                return
            }
            
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueURLEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueURLEnding)
            
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            
            do{
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                completionHandler(attachment)
            }
            catch{
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
    
    
}


