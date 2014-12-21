//
//  AddGoalTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol AddGoalTableViewControllerDelegate: class {
    
    func addGoalTableViewControllerDidCancel(controller: AddGoalTableViewController)
    
    func addGoalTableViewController(controller: AddGoalTableViewController, didFinishAddingItem item: GoalItem)
    
}

class AddGoalTableViewController: UITableViewController, CreateGoalTableViewControllerDelegate, AddExistingGoalTableViewControllerDelegate {
    
    
    //variables
    weak var delegate: AddGoalTableViewControllerDelegate?
    
    
    //IBOutlet
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    //IBAction
    @IBAction func cancel(sender: AnyObject) {
        
        self.delegate?.addGoalTableViewControllerDidCancel(self)
    }
    
    
    //delegate Methods
    func addExistingGoalTableViewController(controller: AddExistingGoalTableViewController, didFinishAddingItem item: GoalItem) {
    
        self.delegate?.addGoalTableViewController(self, didFinishAddingItem: item)
    }
    
    func addExistingGoalTableViewControllerDidCancel(controller: AddExistingGoalTableViewController) {
     
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func createGoalTableViewController(controller: CreateGoalTableViewController, didFinishAddingItem item: GoalItem) {
        
        self.delegate?.addGoalTableViewController(self, didFinishAddingItem: item)
    }
    
    func createGoalTableViewControllerDidCancel(controller: CreateGoalTableViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //sets the delegate 

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCreateGoal" {
            
            let controller = segue.destinationViewController as CreateGoalTableViewController
            
            controller.delegate = self
            
        } else if segue.identifier == "goToAddExistingGoal" {
            
            let controller = segue.destinationViewController as AddExistingGoalTableViewController
            
            controller.delegate = self
        }
    }
}