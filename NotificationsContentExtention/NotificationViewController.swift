//
//  NotificationViewController.swift
//  NotificationsContentExtention
//
//  Created by Naman Jain on 10/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var imageView: UIImageView!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let attachments = notification.request.content.attachments
        for attachment in attachments{
            if attachment.identifier == "picture" {
                guard let data = try? Data(contentsOf: attachment.url) else { return }
                imageView.image = UIImage(data: data)
            }
        }
    }

}
