//
//  MasterTabBarController.swift
//  MTTN
//
//  Created by Naman Jain on 02/04/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CBFlashyTabBarController


class MasterTabBarController: CBFlashyTabBarController {
    
    var ref : DatabaseReference?
    var attendanceVC : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            
        } else {
            setupTheming()
        }
        
        CBFlashyTabBar.appearance().tintColor = UIColor(named: "directoryColor")
        
//        tabBar.isTranslucent = false
//        tabBar.setValue(true, forKey: "hidesShadow")
        
//        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        
        
        let homeNavController = MasterNavigationBarController(rootViewController: WordpressFeedViewController())
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        
        let slcmNavController = MasterNavigationBarController(rootViewController: SLCMViewController())
        slcmNavController.tabBarItem = UITabBarItem(title: "SLCM", image: UIImage(named: "slcm"), tag: 1)
        
        let socialNavController = MasterNavigationBarController(rootViewController: SocialViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        socialNavController.tabBarItem = UITabBarItem(title: "Social", image: UIImage(named: "social"), tag: 2)
        
        let directoryNavController = MasterNavigationBarController(rootViewController: DirectoryViewController())
        directoryNavController.tabBarItem = UITabBarItem(title: "Directory", image: UIImage(named: "directory"), tag: 3)
        
        
        let alertsNavController = MasterNavigationBarController(rootViewController: AlertsViewController())
        alertsNavController.tabBarItem = UITabBarItem(title: "Alerts", image: UIImage(named: "alerts"), tag: 4)

        viewControllers = [homeNavController, slcmNavController, socialNavController, directoryNavController, alertsNavController]
        
        attendanceVC = self.viewControllers![1]
        ref = Database.database().reference()
        
        
        ref?.child("SLCM").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            if let hideSLCM = snapshot.value as? Bool{
                if hideSLCM {
                    self.hide()
                }else{
                    UserDefaults.standard.set(true, forKey: "slcmBackgroundFetch")
                    UserDefaults.standard.synchronize()
                }
                self.slcmListener()
            }
        })
    }
    
    @objc func hide(){
        UserDefaults.standard.set(false, forKey: "slcmBackgroundFetch")
        UserDefaults.standard.synchronize()
        print("HIDING SLCM FROM FIREBASE")
        self.viewControllers?.remove(at: 1)
    }
    @objc func show(){
        UserDefaults.standard.set(true, forKey: "slcmBackgroundFetch")
        UserDefaults.standard.synchronize()
        print("SHOWING SLCM FROM FIREBASE")
        self.viewControllers?.insert(attendanceVC!, at: 1)
    }
    @objc func slcmListener() {
        ref?.child("SLCM").observe(.childChanged, with: { (snapshot) in
            if let hideSLCM = snapshot.value as? Bool{
                if hideSLCM == true {
                    if self.viewControllers?.count == 5{
                        self.hide()
                    }
                }else{
                    if self.viewControllers?.count == 4{
                        self.show()
                    }
                }
            }
        })
    }
}


extension MasterTabBarController: Themed {
    func applyTheme(_ theme: AppTheme) {
        tabBar.barTintColor = theme.barBackgroundColor
        tabBar.tintColor = theme.barForegroundColor
    }
}
