//
//  FavCompanyTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Watch TV Bitch!!! on 11.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class FavCompanyTableViewController: UITableViewController {
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
