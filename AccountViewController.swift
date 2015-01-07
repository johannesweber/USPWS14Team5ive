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
    
    //variable for saving data into core data
    var managedObjectContext: NSManagedObjectContext!
    
    //IBOutlets
    @IBOutlet weak var txtUserMailAddress: UILabel!
    
    //IBAction
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //override methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCompany" {
            
            let yourCompaniesViewController = segue.destinationViewController as YourCompaniesTableViewController
            
            yourCompaniesViewController.managedObjectContext = self.managedObjectContext
            
        }
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

    //methods
    func showCurrentUserMail(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if ((prefs.valueForKey("EMAIL")) != nil){
            var mailAddress:String = prefs.valueForKey("EMAIL") as String
            self.txtUserMailAddress.text = mailAddress
        }
        
    }
}
