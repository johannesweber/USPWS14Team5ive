//
//  EditDevicesViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class EditDevicesTableViewController: UITableViewController {

    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
