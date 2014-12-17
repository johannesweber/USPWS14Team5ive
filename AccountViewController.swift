//
//  AccountViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    var fitbit = Fitbit()
    var medisana = Medisana()
    var withings = Withings()
    
    @IBOutlet weak var txtUserMailAddress: UILabel!
    
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func authorizeFitbit(sender: UIButton) {

        fitbit.doOAuth()
    }
    
    @IBAction func authorizeWithings(sender: UIButton) {
        
        withings.doOAuth()
    }
    
    @IBAction func authorizeMedisana(sender: AnyObject) {
        
        medisana.doOAuth()
    }
    
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

    func showCurrentUserMail(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if ((prefs.valueForKey("EMAIL")) != nil){
            var mailAddress:String = prefs.valueForKey("EMAIL") as String
            self.txtUserMailAddress.text = mailAddress
        }
        
    }
}
