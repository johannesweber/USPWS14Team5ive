//
//  EditGoalsTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class EditGoalsTableViewController: UITableViewController {

    
    @IBAction func done(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)    
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
