//
//  Notifications.swift
//  MTTN
//
//  Created by Naman Jain on 11/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation
import UserNotifications

struct Notifications {
    static let sharedInstance = Notifications()
    
    func scheduleNotificationsForLowAttendance(Attendance: [Attendance]){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        for attendance in Attendance {
            if let Percentage = attendance.Percentage{
                let percentageArray = Percentage.split(separator: ".")
                let percentage = String(percentageArray[0])
                if let percentageInt = Int(percentage) {
                    if percentageInt < 80 && percentageInt > 0{
                        print("Schedule Notif for \(String(describing: attendance.Name)) at \(percentageInt)")
                        
                        if let subjectName = attendance.Name{
                            let content = UNMutableNotificationContent()
                            content.title = "Low Attendance!"
                            content.body = "Your attendance in \(subjectName) is \(percentage)."
                            
                            content.userInfo = ["tab" : "slcm"]
                            content.sound = .default
                            
                            var dateComponents = DateComponents()
                            dateComponents.hour = 18
                            dateComponents.minute = 00
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                            
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                            center.add(request)
                            
                        }
                    }
                }
            }
        }
    }
    
    func scheduleNotificationsForLowAttendance(Attendance: [SISattendance]){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        for attendance in Attendance {
            if let subName = attendance.subjectName{
                if let theoryPerc = attendance.theoryPerc{
                    if let percInt = Int(theoryPerc){
                        if percInt < 80 && percInt > 0 {
                           print("Schedule Notif for \(subName) - Theory at \(percInt)")
                            scheduleNotification(body: "Your attendance in \(subName) - Theory is \(percInt).")
                        }
                    }
                }
                if let practicalPerc = attendance.practicalPerc{
                    if let percInt = Int(practicalPerc){
                        if percInt < 80 && percInt > 0 {
                           print("Schedule Notif for \(subName) - Practical at \(percInt)")
                            scheduleNotification(body: "Your attendance in \(subName) - Practical is \(percInt).")
                        }
                    }
                }
                if let sgtPerc = attendance.sgtPerc{
                    if let percInt = Int(sgtPerc){
                        if percInt < 80 && percInt > 0 {
                           print("Schedule Notif for \(subName) - SGT at \(percInt)")
                            scheduleNotification(body: "Your attendance in \(subName) - SGT is \(percInt).")
                        }
                    }
                }
                if let clinicsPerc = attendance.clinicsPerc{
                    print(clinicsPerc)
                    if let percInt = Int(clinicsPerc){
                        if percInt < 80 && percInt > 0 {
                           print("Schedule Notif for \(subName) - Clinics at \(percInt)")
                            scheduleNotification(body: "Your attendance in \(subName) - Clinics is \(percInt).")
                        }
                    }
                }
            }
        }
    }
    
    
    func scheduleNotification( body: String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Low Attendance!"
        content.body = body //"Your attendance in \(subjectName) is \(percentage)."
        
        content.userInfo = ["tab" : "slcm"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}
