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
    
    var dashboardItems: [TableItem]
    var userId = prefs.integerForKey("USERID") as Int
    
    //initializers
    
    required init(coder aDecoder: NSCoder) {
        
        self.dashboardItems = [TableItem]()
        
        super.init(coder: aDecoder)
    }
    
    //IBAction
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        
        var fitbit = Fitbit()
        fitbit.synchronizeData()
        self.tableView!.reloadData()
    }
    
    //override methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dashboardItems.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DashboardItem") as UITableViewCell
        let item = self.dashboardItems[indexPath.row]
        let label = cell.viewWithTag(6000) as UILabel
        label.text = item.text
        
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
    //cancel method
    func addToDashboardViewControllerDidCancel(controller: AddToDashboardTableViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //method to add new item to dashboard...the item is coming from AddToDashboardTableViewController
    
    func addToDashboardViewController(controller: AddToDashboardTableViewController, didFinishAddingItem item: TableItem) {
        
        let newRowIndex = self.dashboardItems.count
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        self.setValueForItem(item)
        
        if dashboardItems.contains(item){
            println("FOUND")
        } else {
            println("NOT FOUND")
            
            self.dashboardItems.append(item)
            
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func setValueForItem(item: TableItem) {
        
        //variables needed for request
        var date = Date()
        var currentDate = date.getCurrentDateAsString() as String
        var userId = prefs.integerForKey("USERID") as Int
        var url: String = "\(baseURL)/fitbit/time_series/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "endDate"       : "\(currentDate)",
            "limit"         : "1",
            "userId"        : "\(userId)",
            "measurement"   : "\(item.name)"
        ]
        
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                var value = json[0]["value"].intValue
                
                var text = "\(item.name): \(value)"
                
                item.text = text
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
        }
        
    }
    
}