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
    var userId = prefs.integerForKey("USERID") as Int
    var goalItems: [GoalItem]
    
    //init
    required init(coder aDecoder: NSCoder) {
        
        self.goalItems = [GoalItem]()
        
        super.init(coder: aDecoder)
    }
    
    //methods
    //TODO need to rewrite insert and select goals
    func setValueForItem(goal: GoalItem) {
        
        //variables needed for request
        var url: String = "\(baseURL)/goals/select/"
        
        //TODO do i need limit or ?!??
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(self.userId)",
            "measurement"   : "\(goal.name)",
            "period"        : "\(goal.convertPeriodToInt())",
            "company"       : "\(goal.company)",
            "limit"         : "1"
        ]
        
        //wrong user ID stored in Database
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(json)
                
                var currentValue = json[0]["current_value"].intValue
                var targetValue = json[0]["target_value"].intValue
                
                var text = "\(goal.name): \(currentValue)"
                
                goal.text = text
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
        }
        
    }
    
    func insertGoalInDatabase(goal: GoalItem) {
        
        var url = "\(baseURL)/goals/insert/"
        var date = Date()
        var currentDate = date.getCurrentDateAsString() as String
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(self.userId)",
            "measurement"   : "\(goal.name)",
            "period"        : "\(goal.convertPeriodToInt())",
            "startDate"     : "\(currentDate)",
            "company"       : "\(goal.company)",
            "goalValue"     : "\(goal.value)"
        ]
        
        //wrong user ID stored in Database
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in

                println(json)
                
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
            
            showAlert("You have already added \(item.name)", "Please choose another one", self)
            
        } else {
            
            if item.company == "focused health" {
                
                self.insertGoalInDatabase(item)
                
            }
            
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
        
        //TODO Fix progressView 
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalItem") as UITableViewCell
        let item = self.goalItems[indexPath.row]
        let label = cell.viewWithTag(3010) as UILabel
        let progressView = cell.viewWithTag(555) as UIProgressView
        let fractionalProgress = 10.0 / Float(item.value)
        println("Progress View Limit \(Float(item.value))")
        progressView.setProgress(fractionalProgress, animated: true)
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
    

