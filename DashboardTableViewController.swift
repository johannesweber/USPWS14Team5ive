//
//  DashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class DashboardTableViewController: UITableViewController, AddToDashboardTableViewControllerDelegate {
    
    //variables
    var dashboardItems: [MeasurementItem]
    var userId = prefs.integerForKey("USERID") as Int
    var isLoading = false
    var request: Alamofire.Request?
    
    //initializers
    required init(coder aDecoder: NSCoder) {
        
        self.dashboardItems = [MeasurementItem]()
        
        super.init(coder: aDecoder)
    }
    
    struct TableViewCellIdentifiers {
        
        static let loadingCell = "LoadingCell"
    }
    
    //IBAction
    @IBAction func refresh(sender: UIBarButtonItem) {
        
        self.isLoading = true
        self.tableView.reloadData()
        
        let url = "\(baseURL)/fitbit/synchronize/"
        
        let parameters: Dictionary<String, AnyObject> = [
            "userId"    : "\(self.userId)"
        ]
        
        //remove success message from user_info in php
        self.request = Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(json)
         
                var success = json["success"].intValue
                var message = json["message"].stringValue
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.isLoading = false
                    self.tableView.reloadData()
                }
                
                if success == 1 {
                    showAlert(NSLocalizedString("Success!", comment: "Title for Message which appears if request successfully executed"), NSLocalizedString("\(message)", comment: "Message which appears if request successfully executed"), self)
                }
                
        }
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.request?.cancel()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isLoading {
            
            return 1
            
        } else {
            
            return self.dashboardItems.count
        }
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.isLoading {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath:indexPath)
            as UITableViewCell
            let spinner = cell.viewWithTag(100) as UIActivityIndicatorView
            spinner.startAnimating()
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("DashboardItem") as UITableViewCell
            let item = self.dashboardItems[indexPath.row]
            let label = cell.viewWithTag(6000) as UILabel
            label.text = item.text
        
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            return cell
        }
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
    
    func addToDashboardViewController(controller: AddToDashboardTableViewController, didFinishAddingItem item: MeasurementItem) {
        
        let newRowIndex = self.dashboardItems.count
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        if dashboardItems.contains(item){
            
            showAlert(NSLocalizedString("Item already added", comment: "Title for Message which appears if Dashboard already contains that Item"), NSLocalizedString("You have already added \(item.name). Please choose another one", comment: "Message which appears if Dashboard already contains that Item"), self)

            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            self.setValueForItem(item)
            
            self.dashboardItems.append(item)
            
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func setValueForItem(item: MeasurementItem) {
        
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
                
                println(json)
                
                var value = json[0]["value"].doubleValue
                var unit = json[0]["unit"].stringValue
                var date = json[0]["DATE"].stringValue
                
                item.value = value
                item.unit = unit
                item.date = date
                
                item.createTextForDashboard()
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
        }
        
    }
    
}