//
//  AppIconsViewController.swift
//  MTTN
//
//  Created by Naman Jain on 26/10/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class AppIconsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AppIconsTableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AppIconsTableViewCell
        cell.imageView?.image = UIImage(named: "DarkAppIcon")
        cell.textLabel?.text = "Embrace the Dark"
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(named: "AppIcon")
            cell.textLabel?.text = "The Classy One"
            break
        case 1:
            cell.imageView?.image = UIImage(named: "DarkAppIcon")
            cell.textLabel?.text = "Embrace the Dark"
            break
        case 2:
            cell.imageView?.image = UIImage(named: "GreenAppIcon")
            cell.textLabel?.text = "A Tint of Green"
            break
        case 3:
            cell.imageView?.image = UIImage(named: "CrewAppIcon")
            cell.textLabel?.text = "Blend with the Crew"
            break
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            AppIconService().changeAppIcon(to: AppIconService.AppIcon.PrimaryAppIcon)
            break
        case 1:
            AppIconService().changeAppIcon(to: AppIconService.AppIcon.DarkAppIcon)
            break
        case 2:
            AppIconService().changeAppIcon(to: AppIconService.AppIcon.GreenAppIcon)
            break
        case 3:
            AppIconService().changeAppIcon(to: AppIconService.AppIcon.CrewAppIcon)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}



class AppIconsTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageView?.layer.cornerRadius = 10
        imageView?.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
