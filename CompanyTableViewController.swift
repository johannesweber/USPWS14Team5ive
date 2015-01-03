//
//  CompanyTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 03.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit

class CompanyTableViewController: UITableViewController {

  
    //IBOUtlet
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    
    //IBAction
    @IBAction func save(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
