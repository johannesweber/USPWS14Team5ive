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

class CreateGoalTableViewController: UITableViewController, PeriodTableViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    //variables
    
    weak var delegate: CreateGoalTableViewControllerDelegate?
    
    var startdate: NSDate
    var startDatePickerVisible: Bool
    var measurementPickerVisible: Bool
    var measurement: [GoalItem]
    var measurementSelected: GoalItem
    
    //initializers
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurement = [GoalItem]()
        self.measurementSelected = GoalItem()
        self.startdate = NSDate()
        self.startDatePickerVisible = false
        self.measurementPickerVisible = false

        
        let row0item = GoalItem(name: "Steps", nameInDatabase: "steps")
        row0item.sliderLimit = 20000
        row0item.unit = "steps"
        row0item.company = "focused health"
        self.measurement.append(row0item)
        
        super.init(coder: aDecoder)
    }
    
    //IBOutlet
    
    @IBOutlet weak var valueSlider: UISlider!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var measurementDetailLabel: UILabel!
    @IBOutlet weak var periodDetailLabel: UILabel!
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    //IBAction
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        var currentValue = Int(sender.value)
        
        valueLabel.text = "\(currentValue)"
        
        self.checkIfFormIsComplete()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
    
        self.measurementSelected.startdate = self.startDateDetailLabel.text!
        self.measurementSelected.period = self.periodDetailLabel.text!
        self.measurementSelected.value = self.valueLabel.text!.toInt()!
        self.measurementSelected.unit = measurementSelected.unit
        
        self.delegate?.createGoalTableViewController(self, didFinishAddingItem: self.measurementSelected)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //override methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.saveBarButton.enabled = false
        self.valueSlider.enabled = false
        self.unitLabel.textColor = UIColor.grayColor()
        self.valueLabel.textColor = UIColor.grayColor()
        
    }
    
    //Picker View Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.measurement.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.measurement[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var itemSelected = self.measurement[row]
        
        self.measurementDetailLabel.text = itemSelected.name
        
        self.measurementSelected = itemSelected
        
        self.customizeSlider(itemSelected)
        self.unitLabel.textColor = UIColor.blackColor()
        self.valueLabel.textColor = UIColor.blackColor()
        self.valueSlider.enabled = true
        
        self.checkIfFormIsComplete()
    }
    
    //methods
    
    func customizeSlider(item: GoalItem) {
        
        self.valueSlider.maximumValue = Float(item.sliderLimit)
        self.valueSlider.continuous = true
        self.unitLabel.text = item.unit
    }
    
    func checkIfFormIsComplete() {
        
        if measurementDetailLabel.text != "Detail" && periodDetailLabel.text != "Detail" && startDateDetailLabel.text != "Detail" && valueLabel.text != "Value" {
            
            self.saveBarButton.enabled = true
        }
    }
    
    func dateChanged(datePicker: UIDatePicker) {
        self.startdate = datePicker.date
        self.updateDueDateLabel()
        self.checkIfFormIsComplete()
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.dateFormat = "yyyy-MM-dd"
        self.startDateDetailLabel.text = formatter.stringFromDate(startdate)
    }
    
    func showStartDatePicker() {
        
        startDatePickerVisible = true
        
        let indexPathStartDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        tableView.insertRowsAtIndexPaths([indexPathStartDatePicker], withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathStartDatePicker) {
            
            let startDatePicker = pickerCell.viewWithTag(100) as UIDatePicker
            startDatePicker.setDate(startdate, animated: false)
        }
    }
    
    func hideStartDatePicker() {
            
        if startDatePickerVisible {
                
            startDatePickerVisible = false
            let indexPathStartDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathStartDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            if let cell = tableView.cellForRowAtIndexPath(indexPathStartDateRow) {
                
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
                
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathStartDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathStartDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    func showMeasurementPicker() {
        
        self.measurementPickerVisible = true
        let indexPathMeasurementPicker = NSIndexPath(forRow: 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPathMeasurementPicker], withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathMeasurementPicker) {
                
            let measurementPicker = pickerCell.viewWithTag(112) as UIPickerView
        }
    }
    
    func hideMeasurementPicker() {
                
        if self.measurementPickerVisible {
                
            self.measurementPickerVisible = false
            let indexPathMeasurementRow = NSIndexPath(forRow: 0, inSection: 0)
            let indexPathMeasurementPicker = NSIndexPath(forRow: 1, inSection: 0)
                
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathMeasurementRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathMeasurementPicker], withRowAnimation: .Fade)
            tableView.endUpdates()
            
        }
    }
    
    
    //table view methods
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   
        if indexPath.section == 1 && indexPath.row == 2 {
    
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("StartDatePickerCell") as? UITableViewCell
        
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: "StartDatePickerCell")
            cell.selectionStyle = .None
 
            let startDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
            startDatePicker.tag = 100
            startDatePicker.datePickerMode = UIDatePickerMode.Date
            cell.contentView.addSubview(startDatePicker)
     
            startDatePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
        }
        
        return cell
   
        } else  if indexPath.section == 0 && indexPath.row == 1 {
        
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("MeasurementPickerCell") as? UITableViewCell
        
            if cell == nil {
                    
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "MeasurementPickerCell")
                    cell.selectionStyle = .None
                    
                    let measurementPicker = UIPickerView (frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                    measurementPicker.tag = 112
                    measurementPicker.dataSource = self
                    measurementPicker.delegate = self
                    cell.contentView.addSubview(measurementPicker)
            }
        
            return cell

        } else {
        
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && startDatePickerVisible {
            
            return 3
            
        } else if section == 0 && measurementPickerVisible {
                
                return 2
                
            } else {
            
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2 {
                
            return 217
                
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
                return 217
            
        } else {
            
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 1 {
        
            if !startDatePickerVisible {
        
                showStartDatePicker()
        
            } else {
        
                hideStartDatePicker()
            }
            
        } else if indexPath.section == 0 && indexPath.row == 0 {
            
            if !measurementPickerVisible {
            
                showMeasurementPicker()
                
            } else {
                
                hideMeasurementPicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
        if indexPath.section == 1 && indexPath.row == 1 || indexPath.section == 1 && indexPath.row == 0 || indexPath.section == 0 && indexPath.row == 0{
            
            return indexPath
            
        } else {
            
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 1 && indexPath.row == 2 || indexPath.section == 0 && indexPath.row == 1{
        
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
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
        
        self.periodDetailLabel.text = item.name
        
        self.navigationController?.popViewControllerAnimated(true)
        
        self.checkIfFormIsComplete()
        
    }
}
