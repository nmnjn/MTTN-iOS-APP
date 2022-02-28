//
//  AppDelegate.swift
//  MTTN
//
//  Created by Naman Jain on 02/04/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseMessaging
import UserNotifications
import SafariServices
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{

    var window: UIWindow?
    var ref: DatabaseReference?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MasterTabBarController()
        
        setAppTheme()
        
        fetchAPIUrlFromFirebase()
//        requestNotificationAuthorization(application: application)
        application.registerForRemoteNotifications()
        handleApplicationStartingFromNotification(launchOptions: launchOptions)
        
        // Setup Fetch Interval - 5 Hours
        UIApplication.shared.setMinimumBackgroundFetchInterval(1800)
        StoreKitHelper.incrementNumberOfTImesLaunched()
        StoreKitHelper.displayRequestRatings()
        
        DropDown.startListeningToKeyboard()
        
        return true
    }
    
    private func requestNotificationAuthorization(application: UIApplication){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let err = error{
                print(err)
            }
            UserDefaults.standard.set(success, forKey: "userHasEnabledFetch")
            UserDefaults.standard.synchronize()
        }
        application.registerForRemoteNotifications()
    }
    
    private func setAppTheme() {
        AppThemeProvider.shared.currentTheme = UserDefaults.standard.darkModeEnabled ? .dark : .light
    }
    
    private func fetchAPIUrlFromFirebase(){
        ref = Database.database().reference()
        ref?.child("URL").observe(.childAdded, with: { (snapshot) in
            if snapshot.key == "SLCM"{
                if let string = snapshot.value as? String{
                    print("SLCM URL FROM FIREBASE FETCHED SUCCESSFULLY")
                    UserDefaults.standard.set(string, forKey: "SLCM")
                    UserDefaults.standard.synchronize()
                    let url = string.components(separatedBy: "/attendance")
                    let str = url[0]+"/get-captcha"
                    UserDefaults.standard.set(str ,forKey: "SLCM_Captcha")
                    UserDefaults.standard.synchronize()
                }
            }
            if snapshot.key == "SIS Data"{
                if let string = snapshot.value as? String{
                    print("SIS URL FROM FIREBASE FETCHED SUCCESSFULLY")
                    UserDefaults.standard.set(string, forKey: "SIS")
                    UserDefaults.standard.synchronize()
                }
            }
            if snapshot.key == "Instagram Graph"{
                if let string = snapshot.value as? String{
                    print("INSTAGRAM URL FROM FIREBASE FETCHED SUCCESSFULLY")
                    UserDefaults.standard.set(string, forKey: "Instagram")
                    UserDefaults.standard.synchronize()
                }
            }
            if snapshot.key == "YouTube"{
                if let string = snapshot.value as? String{
                    print("YOUTUBE URL FROM FIREBASE FETCHED SUCCESSFULLY")
                    UserDefaults.standard.set(string, forKey: "YouTube")
                    UserDefaults.standard.synchronize()
                }
            }
            if snapshot.key == "NoirSelect"{
                if let string = snapshot.value as? String{
                    print("NOIR SELECT URL FROM FIREBASE FETCHED SUCCESSFULLY")
                    UserDefaults.standard.set(string, forKey: "NoirSelect")
                    UserDefaults.standard.synchronize()
                }
            }
            if snapshot.key == "Playlist"{
                if let string = snapshot.value as? String{
                    print("PLAYLIST URL FROM FIREBASE FETCHED SUCCESSFULLY")
                    UserDefaults.standard.set(string, forKey: "Playlist")
                    UserDefaults.standard.synchronize()
                }
            }
            if snapshot.key == "Twitter"{
                if let string = snapshot.value as? String{
                    print("TWITTER URL FROM FIREBASE FETCHED SUCCESSFULLY")
                    UserDefaults.standard.set(string, forKey: "Twitter")
                    UserDefaults.standard.synchronize()
                }
            }
            
            
        }, withCancel: { (error) in
            print(error)
            print("Using Local Url")
        })
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //this function is used to save fcmToken in UserDefaults
        print("fcmToken: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        UserDefaults.standard.synchronize()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        FBHandler(value: false)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        FBHandler(value: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @objc func FBHandler(value: Bool) {
        Messaging.messaging()
    }
    
    func handleApplicationStartingFromNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        if let tempDictionary = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String : AnyObject] {
            if let url = tempDictionary["url"] as? String{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    //delaying time to open the link...
                    self.openLink(url: url)
                }
            }
            if let tabName = tempDictionary["tab"] as? String{
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.goToTab(tabName: tabName)
                }
            }
        }
    }
    
    open func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        if let url = userInfo[AnyHashable("url")] as? String{
            openLink(url: url)
        }
        if let tabName = userInfo[AnyHashable("tab")] as? String{
            goToTab(tabName: tabName)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Name"), object: userInfo)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Received Notification")
        let userInfo = response.notification.request.content.userInfo
        if let url = userInfo[AnyHashable("url")] as? String{
            openLink(url: url)
        }
        if let tabName = userInfo[AnyHashable("tab")] as? String{
            goToTab(tabName: tabName)
        }
//        NotificationCenter.default.post(name: NSNotification.Name, object: response)
        completionHandler()
    }
    
    
    
    
    func openLink(url: String){
        if let urlLink = URL(string: url){
            let safari = SFSafariViewController(url: urlLink)
            let topMostViewController = UIApplication.shared.topMostViewController()
            topMostViewController?.present(safari, animated: true, completion: nil)
        }
    }
    
    func goToTab(tabName: String){
        if let myTabBar = self.window?.rootViewController as? UITabBarController{
            switch tabName{
            case "alerts": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?4:3
                break
            case "directory": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?3:2
                break
            case "social": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?2:1
                break
            case "slcm": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?1:0
                break
            case "feed": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?0:0
            default: break
            }
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let myTabBar = self.window?.rootViewController as? UITabBarController{
            switch shortcutItem.type{
            case "com.gauravanandprakash.mttn.alerts": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?4:3
                break
            case "com.gauravanandprakash.mttn.directory": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?3:2
                break
            case "com.gauravanandprakash.mttn.social": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?2:1
                break
            case "com.gauravanandprakash.mttn.slcm": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?1:0
                break
            case "com.gauravanandprakash.mttn.home": myTabBar.selectedIndex = myTabBar.tabBar.items?.count == 5 ?0:0
            default: break
            }
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            if UserDefaults.standard.bool(forKey: "slcmBackgroundFetch"){
                if UserDefaults.standard.isLoggedIn(){
                    var parameters : [String: String]
                    if let para = UserDefaults.standard.dictionary(forKey: "parameter"){
                        parameters = para as! [String : String]
                        if UserDefaults.standard.bool(forKey: "isSis"){
                            Networking.sharedInstance.fetchSISData(Parameters: parameters, dataCompletion: { (attendance) in
                                if UserDefaults.standard.bool(forKey: "userHasEnabledFetch"){
                                    var highestSem = ""
                                    for semester in attendance{
                                        if semester.key > highestSem {
                                            highestSem = semester.key
                                        }
                                    }
                                    if highestSem == ""{
                                        completionHandler(.failed)
                                        return
                                    }else{
                                        Notifications.sharedInstance.scheduleNotificationsForLowAttendance(Attendance: attendance[highestSem]!)
                                        completionHandler(.newData)
                                    }
                                    
                                }else{
                                    print("****   NOTIFICATIONS SCHEDULING IS DISABLED BY USER   ****")
                                    completionHandler(.newData)
                                    return
                                }
                            }) { (error) in
                                    print(error)
                                    completionHandler(.failed)
                            }
                        }else{
                            Networking.sharedInstance.fetchSLCMData(Parameters: parameters, dataCompletion: { (attendance, marks,credits) in
                                if UserDefaults.standard.bool(forKey: "userHasEnabledFetch"){
                                    Notifications.sharedInstance.scheduleNotificationsForLowAttendance(Attendance: attendance)
                                    completionHandler(.newData)
                                }else{
                                    print("****   NOTIFICATIONS SCHEDULING IS DISABLED BY USER   ****")
                                    completionHandler(.newData)
                                    return
                                }
                                
                            }) { (error) in
                                print(error)
                                completionHandler(.failed)
                            }
                        }
                    }else{
                        print("****   SLCM BACKGROUND FETCH CANNOT TAKE PLACE AS USER PARAMETERS ARE NOT FOUND   ****")
                        completionHandler(.noData)
                        return
                    }
                }else{
                    print("****   SLCM BACKGROUND FETCH CANNOT TAKE PLACE AS USER IS NOT LOGGED IN   ****")
                    completionHandler(.noData)
                    return
                }
                
            }else{
                print("****   SLCM BACKGROUND FETCH DISABLED BECAUSE SLCM IS TURNED OFF FROM FIREBASE  ****")
                completionHandler(.noData)
                return
        }
    }
}
