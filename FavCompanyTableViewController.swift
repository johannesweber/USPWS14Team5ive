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
    var companies: [CompanyItem]
    var companySelected: CompanyItem
    
    //Initializer
    required init(coder aDecoder: NSCoder) {
        
        self.companies = [CompanyItem]()
        self.companySelected = CompanyItem()
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
