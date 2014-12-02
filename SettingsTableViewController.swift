//
//  SettingsTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var settings: [TableItem]
    
    required init(coder aDecoder: NSCoder) {
        
        self.settings = [TableItem]()
        
        let row00item = TableItem(text: "Your Devices")
        settings.append(row00item)
        
        let row0item = TableItem(text: "Change E - Mail")
        settings.append(row0item)
        
        let row1item = TableItem(text: "Change - Password")
        settings.append(row1item)
        
        let row2item = TableItem(text: "Set Favorite Company")
        settings.append(row2item)
        
        super.init(coder: aDecoder)
    }
    
    
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return settings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsItem") as UITableViewCell
        let item = settings[indexPath.row]
        let label = cell.viewWithTag(4010) as UILabel
        label.text = item.text
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        var item = settings[indexPath.row]
        var category = item.text
        
        switch category {
            
        case "Your Devices":
            self.performSegueWithIdentifier("goToDevices", sender: self)
        case "Change E - Mail":
            self.performSegueWithIdentifier("goToEMail", sender: self)
        case "Change - Password":
            self.performSegueWithIdentifier("goToPassword", sender: self)
        case "Set Favorite Company":
            self.performSegueWithIdentifier("goToFavCompany", sender: self)
        default:
            println("default (check ViewController tableView)")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }


}
