//
//  FavCompanyTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 11.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class FavCompanyTableViewController: UITableViewController {
    
    //variables
    var companies: [TableItem]
    var companySelected: TableItem
    
    //Initializer
    required init(coder aDecoder: NSCoder) {
        
        self.companies = [TableItem]()
        self.companySelected = TableItem()
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
