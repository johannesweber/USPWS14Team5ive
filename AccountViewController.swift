//
//  AccountViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    @IBOutlet weak var txtUserMailAddress: UILabel!
    

    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func welcomeMessage(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if ((prefs.valueForKey("EMAIL")) != nil){
            var mailAddress:String = prefs.valueForKey("EMAIL") as String
            self.txtUserMailAddress.text = mailAddress
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("goToSettings", sender: self)
        
        } else if indexPath.section == 1 && indexPath.row == 1 {
            self.performSegueWithIdentifier("goToAbout", sender: self)
        
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.welcomeMessage()
    }
}
