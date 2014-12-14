//
//  AddToDashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AddToDashboardTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Variables
    
    var dueDate = NSDate()
    var datePickerVisible = false
    var measurement = ["Steps", "Duration", "Distance", "Calories burned", "Elevation", "Body Weight", "Body Height", "BMI", "Body Fat", "Blood Pressure", "Heart Rate", "Glucose", "Food", "Water", "Calories eaten", "Sleep Analysis"]
    var measurementSelected = String()
    
    //IBOutlet
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    //IBAction
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        
        println(self.measurementSelected)
        
    }
    
    //Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.measurement.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.measurement[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.measurementSelected = self.measurement[row]
    }
    
    
    func showDatePicker() {
        datePickerVisible = true
        let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            
            let datePicker = pickerCell.viewWithTag(111) as UIPickerView
        }
    }
    
    func hideDatePicker() {
            if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 0)
            let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
            
            }
    }
    
    //Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1
        if indexPath.section == 0 && indexPath.row == 1 {
            // 2
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("MeasurementPickerCell") as? UITableViewCell
                
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "MeasurementPicker")
                cell.selectionStyle = .None
                // 3
                let datePicker = UIPickerView (frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 111
                datePicker.dataSource = self
                datePicker.delegate = self
                cell.contentView.addSubview(datePicker)
            }
            return cell
        // 5
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && datePickerVisible {
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
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 0 {
                    
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
    
}
