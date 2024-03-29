//
//  AddGoalTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

/*
*
* These methods in this protocol are called if a goal is created or the view did cancel. the delegate is for delegating the created item/goal back to
* the AddGoalTableViewController.
*
*/

protocol AddGoalTableViewControllerDelegate: class {
    
    func addGoalTableViewControllerDidCancel(controller: AddGoalTableViewController)
    
    func addGoalTableViewController(controller: AddGoalTableViewController, didFinishAddingItem item: GoalItem)
    
}

/*
*
* This controller adds a new Goal to the Goal Table View.
*
*/

class AddGoalTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //variables
    weak var delegate: AddGoalTableViewControllerDelegate?
    
    var goalPickerVisible: Bool
    var goal: [GoalItem]
    var goalSelected: GoalItem
    var newCreatedGoal: GoalItem

    //initializer
    required init(coder aDecoder: NSCoder) {
        
        self.goalPickerVisible = false
        self.goal = [GoalItem]()
        self.goalSelected = GoalItem()
        self.newCreatedGoal = GoalItem()
        
        super.init(coder: aDecoder)
    }

    
    //IBOutlet
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var measurementDetailLabel: UILabel!
    @IBOutlet weak var goalDetailLabel: UILabel!
    
    //IBAction
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done (sender: UIBarButtonItem) {
            
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    //Goal Picker View Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.goal.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.goal[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.goalSelected = self.goal[row]
        self.measurementDetailLabel.text = self.goalSelected.name
        self.doneBarButton.enabled = true
    }

    
    //delegate Methods
    
    func createGoalTableViewController(controller: CreateGoalTableViewController, didFinishAddingItem item: GoalItem) {
        
        self.goalDetailLabel.text = item.name
        self.newCreatedGoal = item
        
        self.doneBarButton.enabled = true
        
    }
    
    func createGoalTableViewControllerDidCancel(controller: CreateGoalTableViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    //Override Function
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        self.doneBarButton.enabled = false
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("GoalPickerCell") as? UITableViewCell
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "GoalPicker")
                cell.selectionStyle = .None
                
                let goalPicker = UIPickerView (frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                goalPicker.tag = 112
                goalPicker.dataSource = self
                goalPicker.delegate = self
                cell.contentView.addSubview(goalPicker)
            }
            return cell
            
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && self.goalPickerVisible {
            
            return 2
            
        } else {
            
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            return 217
            
        } else {
            
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            if !self.goalPickerVisible {
                
                showGoalPicker()
                
            } else {
                
                hideGoalPicker()
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 0 || indexPath.section == 1 && indexPath.row == 0{
            
            return indexPath
            
        } else {
            
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            
        }
        
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    //methods
    
    func showGoalPicker() {
        
        self.goalPickerVisible = true
        let indexPathGoalPicker = NSIndexPath(forRow: 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPathGoalPicker], withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathGoalPicker) {
            
            let goalPicker = pickerCell.viewWithTag(112) as UIPickerView
        }
    }
    
    func hideGoalPicker() {
        
        if self.goalPickerVisible {
            self.goalPickerVisible = false
            let indexPathGoalRow = NSIndexPath(forRow: 0, inSection: 0)
            let indexPathGoalPicker = NSIndexPath(forRow: 1, inSection: 0)
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathGoalRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathGoalPicker], withRowAnimation: .Fade)
            tableView.endUpdates()
            
        }
    }


}