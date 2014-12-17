//
//  AddToDashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol AddToDashboardTableViewControllerDelegate: class {
    
    func addToDashboardViewControllerDidCancel(controller: AddToDashboardTableViewController)
    func addToDashboardViewController(controller: AddToDashboardTableViewController, didFinishAddingItem item: DashboardItem)
}

class AddToDashboardTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Variables
    
    var measurementPickerVisible = false
    var measurement: [DashboardItem]
    var measurementSelected = String()
        
    weak var delegate: AddToDashboardTableViewControllerDelegate?
    
    //initializer
        
    required init(coder aDecoder: NSCoder) {
    
        self.measurement = [DashboardItem]()
    
        let row0item = DashboardItem(itemName: "steps")
        self.measurement.append(row0item)
        
        let row2item = DashboardItem(itemName: "distance")
        self.measurement.append(row2item)
        
        let row3item = DashboardItem(itemName: "calories_out")
        self.measurement.append(row3item)
        
        let row4item = DashboardItem(itemName: "elevation")
        self.measurement.append(row4item)
        
        let row5item = DashboardItem(itemName: "weight")
        self.measurement.append(row5item)
        
        //user info
        let row6item = DashboardItem(itemName: "height")
        self.measurement.append(row6item)
        
        let row7item = DashboardItem(itemName: "bmi")
        self.measurement.append(row7item)
        
        let row8item = DashboardItem(itemName: "fat")
        self.measurement.append(row8item)
        
        let row12item = DashboardItem(itemName: "water")
        self.measurement.append(row12item)
        
        let row13item = DashboardItem(itemName: "calories_in")
        self.measurement.append(row13item)
        
        let row14item = DashboardItem(itemName: "sleep")
        self.measurement.append(row14item)
        
        let row15item = DashboardItem(itemName: "floors")
        self.measurement.append(row15item)
        
        super.init(coder: aDecoder)
    }
        
    //IBOutlet
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //IBAction
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.delegate?.addToDashboardViewControllerDidCancel(self)
    }
    
    //TODO disable done button if no measurment is added
    @IBAction func done(sender: UIBarButtonItem) {
        
        let newDashboardItem = DashboardItem(itemName: self.measurementSelected)
        
        newDashboardItem.getValueForLabel()
        
        newDashboardItem.getValue()
        
        self.delegate?.addToDashboardViewController(self, didFinishAddingItem: newDashboardItem)
        
    }
    
    //Picker View Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.measurement.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.measurement[row].itemName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
        self.measurementSelected = self.measurement[row].itemName
        self.doneBarButton.enabled = true
    }
    
    
    func showMeasurementPicker() {
        
        self.measurementPickerVisible = true
        let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            
            let datePicker = pickerCell.viewWithTag(111) as UIPickerView
        }
    }
    
    func hideMeasurementPicker() {
        
            if self.measurementPickerVisible {
            self.measurementPickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 0)
            let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 0)
        
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
        
        self.doneBarButton.enabled = false
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
        if section == 0 && self.measurementPickerVisible {
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
            
            if !self.measurementPickerVisible {
                
                showMeasurementPicker()
            
            } else {
                
                hideMeasurementPicker()
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
