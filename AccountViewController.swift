//
//  AccountViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UITableViewController {
    
    //IBOutlets
    @IBOutlet weak var txtUserMailAddress: UILabel!
    
    //IBAction
    @IBAction func logoutTapped(sender: UIButton) {
            
//        let appDomain = NSBundle.mainBundle().bundleIdentifier
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        //sets key FIRSTTIMELOGIN to NO and ISLOGGEDIN to 0
        prefs.setObject("NO", forKey: "FIRSTTIMELOGIN")
        prefs.setInteger(0, forKey: "ISLOGGEDIN")
        prefs.synchronize()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //override methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("goToCompany", sender: self)
            
        } else if indexPath.section == 1 && indexPath.row == 1 {
            self.performSegueWithIdentifier("goToAbout", sender: self)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.showCurrentUserMail()
    }

    //methods
    //shows mail from currently logged in user
    func showCurrentUserMail(){
        if ((prefs.valueForKey("EMAIL")) != nil){
            var mailAddress:String = prefs.valueForKey("EMAIL") as String
            self.txtUserMailAddress.text = mailAddress
        }
        
    }
}
