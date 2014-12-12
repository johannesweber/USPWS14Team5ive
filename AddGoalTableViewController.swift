//
//  AddGoalTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol AddGoalTableViewControllerDelegate: class {
    
    func addGoalTableViewControllerDidCancel(controller: AddGoalTableViewController)
    
    func addGoalTableViewController(controller: AddGoalTableViewController,
    didFinishAddingItem item: TableItem)
    
}

class AddGoalTableViewController: UITableViewController {
    
    @IBOutlet weak var startdateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var targetValueLabel: UILabel!

    weak var delegate: AddGoalTableViewControllerDelegate?
    
    var startdate = NSDate()
    var enddate = NSDate()
    
    var startDatePickerVisible = false
    var endDatePickerVisible = false
    
    @IBAction func targetValueSlider(sender: UISlider) {
        
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        
        let item = TableItem()
        //Hier kommt später das datum hin
        //        item.text = textField.text
        delegate?.addGoalTableViewController(self, didFinishAddingItem: item)
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        
        delegate?.addGoalTableViewControllerDidCancel(self)
    }
    
    func showStartDatePicker() {
        
        //sets the startdatepicker variable to true to indace that the startdatepicker is visible
        self.startDatePickerVisible = true
        //defines the indexpath where the datepicker should be
        let indexPathStartDatePicker = NSIndexPath(forRow: 1, inSection: 1)
        tableView.insertRowsAtIndexPaths([indexPathStartDatePicker],
        withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            // 1 if the cell with the datepicker is active
            if indexPath.section == 1 && indexPath.row == 1 {
            // 2 Select the cell with the startDatePicker in it
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("StartDatePickerCell") as? UITableViewCell
                if cell == nil {
                    //create a new table cell
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "StartDatePickerCell")
                    cell.selectionStyle = .None
                    // 3 create a new date picker
                    let startDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                    startDatePicker.tag = 100
                    //add the date picker to the cell
                    cell.contentView.addSubview(startDatePicker)
                    // 4
                    startDatePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
                }
                return cell
            // 5
            } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && self.startDatePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
                
        if indexPath.section == 1 && indexPath.row == 1 {
                
                return 218
                
        } else {
                
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
                
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                        
            if indexPath.section == 1 && indexPath.row == 0 {
                        
                showStartDatePicker()
            }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
                    
        if indexPath.section == 1 && indexPath.row == 0 {
                    
            return indexPath
                    
        } else {
                    
            return nil
                    
        }
    }
    
    override func tableView(tableView: UITableView,
        var indentationLevelForRowAtIndexPath indexPath: NSIndexPath)
        -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
        indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView,
        indentationLevelForRowAtIndexPath: indexPath)
    }

}
