//
//  DashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import AlamoFire

class DashboardTableViewController: UITableViewController, AddToDashboardTableViewControllerDelegate {
    
    //variables
    
    var dashboardItems: [DashboardItem]
    var userId = prefs.integerForKey("USERID") as Int
    
    //initializers
    
    required init(coder aDecoder: NSCoder) {
        
        self.dashboardItems = [DashboardItem]()
        
        var row0Item = DashboardItem(itemName: "steps")
        self.dashboardItems.append(row0Item)
        
        super.init(coder: aDecoder)
    }
    
    //IBAction methods

    
    
    //override methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dashboardItems.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DashboardItem") as UITableViewCell
        let item = self.dashboardItems[indexPath.row]
        let label = cell.viewWithTag(6000) as UILabel
        label.text = item.itemName
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

            self.dashboardItems.removeAtIndex(indexPath.row)

            let indexPaths = [indexPath]
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    //sets the delegate for AddToDashboardtableViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addToDashboard" {

            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as AddToDashboardTableViewController

            controller.delegate = self
        }
    }
    
    //delegate methods
    
    func addToDashboardViewControllerDidCancel(controller: AddToDashboardTableViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addToDashboardViewController(controller: AddToDashboardTableViewController, didFinishAddingItem item: DashboardItem) {
        
        let newRowIndex = self.dashboardItems.count
        self.dashboardItems.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    

}