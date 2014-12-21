//
//  GoalsTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GoalsTableViewController: UITableViewController, AddGoalTableViewControllerDelegate {
    
    //variables
    var goalItems: [GoalItem]
    
    //init
    required init(coder aDecoder: NSCoder) {
        
        self.goalItems = [GoalItem]()
        
        super.init(coder: aDecoder)
    }
    
    //methods
    func setValueForItem(item: GoalItem) {
        
        //variables needed for request
        var date = Date()
        var currentDate = date.getCurrentDateAsString() as String
        var userId = prefs.integerForKey("USERID") as Int
        var url: String = "\(baseURL)/fitbit/goals/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(userId)",
            "measurement"   : "\(item.name)",
            "period"        : "1"
        ]
        
        //wrong user ID stored in Database
        Alamofire.request(.GET, url, parameters: parameters)
            .responseString { (request, response, json, error) in
                
                println(request)
                println(json)
                
//                var value = json[0]["value"].intValue
//                
//                var text = "\(item.name): \(value)"
//                
//                item.text = text
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.tableView!.reloadData()
//                })
        }
        
    }

    
    
    //create delegate
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
        
        if segue.identifier == "goToAddGoal" {

            let navigationController = segue.destinationViewController as UINavigationController

            let controller = navigationController.topViewController as AddGoalTableViewController

            controller.delegate = self
        }
    }
    
    //delegate methods
    
    func addGoalTableViewController(controller: AddGoalTableViewController, didFinishAddingItem item: GoalItem) {
        
        let newRowIndex = self.goalItems.count
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        if goalItems.contains(item){
            
            println("FOUND")
            
        } else {
            
            println("NOT FOUND")
            
            self.setValueForItem(item)
            
            self.goalItems.append(item)
            
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func addGoalTableViewControllerDidCancel(controller: AddGoalTableViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //override methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.goalItems.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalItem") as UITableViewCell
        let item = self.goalItems[indexPath.row]
        let label = cell.viewWithTag(3010) as UILabel
        label.text = item.text
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.goalItems.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }


}
    

