//
//  AboutTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {

    
    //TODO wie hole ich mir die bestehenden views für disclaimer etc.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            //self.performSegueWithIdentifier("goToTerms", sender: self)
            
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            //self.performSegueWithIdentifier("goToAbout", sender: self)
            
        }
        if indexPath.section == 1 && indexPath.row == 2 {
            //self.performSegueWithIdentifier("goToDisclaimer", sender: self)
        }

    }
    
    
}