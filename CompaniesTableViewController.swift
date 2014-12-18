//
//  DevicesTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class CompaniesTableViewController: UITableViewController, AddCompanyTableViewControllerDelegate {
    
    //variables
    
    var companyItems: [TableItem]
    
    //initializers
    
    required init(coder aDecoder: NSCoder) {
        
        self.companyItems = [TableItem]()
        
        super.init(coder: aDecoder)
    }
    
    //override methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.companyItems.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyItem") as UITableViewCell
        
        let item = self.companyItems[indexPath.row]
        
        let label = cell.viewWithTag(4060) as UILabel
        label.text = item.text
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.companyItems.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    //sets the delegate for AddToDashboardtableViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToAddCompany" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as AddCompanyTableViewController
            
            controller.delegate = self
        }
    }

    
    
    // Delegate Methods
    func addCompanyTableViewControllerDidCancel(controller: AddCompanyTableViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func addCompanyTableViewController(controller: AddCompanyTableViewController, didFinishAddingItem item: TableItem) {
        
        let newRowIndex = self.companyItems.count
        self.companyItems.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
