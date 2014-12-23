//
//  CreateGoalTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol CreateGoalTableViewControllerDelegate: class {
    
    func createGoalTableViewControllerDidCancel(controller: CreateGoalTableViewController)
    
    func createGoalTableViewController(controller: CreateGoalTableViewController, didFinishAddingItem item: GoalItem)
    
}

class CreateGoalTableViewController: UITableViewController, PeriodTableViewControllerDelegate {

    //variables
    
    weak var delegate: CreateGoalTableViewControllerDelegate?
    
    var startdate = NSDate()
    
    var startDatePickerVisible = false
    
    
    //IBAction
    
    @IBAction func targetValueSlider(sender: UISlider) {
        
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
    
        var newGoalItem = GoalItem(name: "Neu")
        
        self.delegate?.createGoalTableViewController(self, didFinishAddingItem: newGoalItem)
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //delegate methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToPeriod" {
            
            let controller = segue.destinationViewController as PeriodTableViewController
            
            controller.delegate = self
        }
    }
    
    func periodViewControllerDidCancel(controller: PeriodTableViewController) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func periodViewController(controller: PeriodTableViewController, didFinishSelectingPeriod item: TableItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
