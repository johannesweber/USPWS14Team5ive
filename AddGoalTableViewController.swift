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
    
    //    //mit dieser funktion wird die auswahl der kategorie geöffnet sobald man die view öffnet
    //    override func viewWillAppear(animated: Bool) {
    //            super.viewWillAppear(animated)
    //            textField.becomeFirstResponder()
    //    }

    
    func showStartDatePicker() {
        startDatePickerVisible = true
        
        let indexPathStartDateRow = NSIndexPath(forRow: 0, inSection: 1)
        let indexPathStartDatePicker = NSIndexPath(forRow: 1, inSection: 1)
            if let dateCell = tableView.cellForRowAtIndexPath(indexPathStartDateRow){
        
                dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
            }
        
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([indexPathStartDatePicker],withRowAnimation: .Fade)
            tableView.reloadRowsAtIndexPaths([indexPathStartDateRow], withRowAnimation: .None)
            tableView.endUpdates()
                if let pickerCell = tableView.cellForRowAtIndexPath(indexPathStartDatePicker) {
                    let startdatePicker = pickerCell.viewWithTag(100) as UIDatePicker
                    startdatePicker.setDate(startdate, animated: false)
                }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1
        if indexPath.section == 1 && indexPath.row == 1 {
        // 2
            var cell: UITableViewCell! =
            tableView.dequeueReusableCellWithIdentifier("StartDatePickerCell") as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "StartDatePickerCell")
                cell.selectionStyle = .None
                // 3
                let startdatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0,
                width: 320, height: 216))
                startdatePicker.tag = 100
                cell.contentView.addSubview(startdatePicker)
                // 4
                startdatePicker.addTarget(self, action: Selector("startDateChanged:"),
                forControlEvents: .ValueChanged)
            }
            return cell
            // 5
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && startDatePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
        
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
        if indexPath.section == 1 && indexPath.row == 1 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath
            indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            if !startDatePickerVisible {
                showStartDatePicker()
            } else {
                hideStartDatePicker()
            }
        }
    }
        
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 0 {
            return indexPath
        } else {
            return nil
        }
    }
        
    override func tableView(tableView: UITableView,var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 1 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
            return super.tableView(tableView,
            indentationLevelForRowAtIndexPath: indexPath)
    }
        
    func updateStartDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        startdateLabel.text = formatter.stringFromDate(startdate)
    }
        
    func startDateChanged(datePicker: UIDatePicker) {
        startdate = datePicker.date
        updateStartDateLabel()
    }
        
    func hideStartDatePicker() {
        if startDatePickerVisible {
            startDatePickerVisible = false
            let indexPathStartDateRow = NSIndexPath(forRow: 0, inSection: 1)
            let indexPathStartDatePicker = NSIndexPath(forRow: 1, inSection: 1)
            if let cell = tableView.cellForRowAtIndexPath(indexPathStartDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathStartDateRow],
            withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathStartDatePicker],
            withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
        
}
