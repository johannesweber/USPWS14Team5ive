//
//  CreateValueTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 03.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateValueTableViewController: UITableViewController, CompanyTableViewControllerDelegate {


    //variables
    var currentMeasurement: MeasurementItem
    var date: NSDate
    var datePickerVisible: Bool
    var userId = prefs.integerForKey("USERID") as Int
    var companySelected: TableItem
    
    //init
    required init(coder aDecoder: NSCoder) {
        
        self.currentMeasurement = MeasurementItem()
        self.date = NSDate()
        self.datePickerVisible = false
        self.companySelected = TableItem()
        
        super.init(coder: aDecoder)
    }
    
    //IBOutlet
    @IBOutlet weak var companyDetailLabel: UILabel!
    @IBOutlet weak var dateDetailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var valueSlider: UISlider!
    
    //IBAction
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        self.insertValueIntoDatabase()
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        var currentValue = Int(sender.value)
        
        self.valueLabel.text = "\(currentValue)"
        
        self.checkIfFormIsComplete()
        
    }
    
    //methods
    func insertValueIntoDatabase() {
        
        let parameters: Dictionary<String, AnyObject> = [
            "userId"      : "\(self.userId)",
            "company"     : "\(self.companySelected.nameInDatabase)",
            "measurement" : "\(self.currentMeasurement.nameInDatabase)",
            "date"        : "\(self.dateDetailLabel.text!)",
            "value"       : "\(self.valueLabel.text!)"
        ]
        
        Alamofire.request(.GET, "\(baseURL)/value/insert", parameters: parameters)
            .responseSwiftyJSON{ (request, response, json, error) in

                var success = json["success"].intValue
                var message = json["message"].stringValue
                
                if success == 1 {
                    
                    showAlert("Success!", message, self)
                }
        }
        
    }
    
    func customizeViewController() {
        
        self.saveBarButton.enabled = false
        self.title = "Create \(self.currentMeasurement.name)"
        self.valueSlider.maximumValue = self.currentMeasurement.sliderLimit
        self.unitLabel.text = currentMeasurement.unit
    }
    
    func dateChanged(datePicker: UIDatePicker) {
        self.date = datePicker.date
        self.updateDueDateLabel()
        self.checkIfFormIsComplete()
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateDetailLabel.text = formatter.stringFromDate(date)
    }
    
    func checkIfFormIsComplete() {
        
        if dateDetailLabel.text != "Detail" && valueLabel.text != "Value" && companyDetailLabel.text != "Detail" {
            
            self.saveBarButton.enabled = true
        }
    }
    
    func showDatePicker() {
        
        self.datePickerVisible = true
        
        let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 1)
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            
            let datePicker = pickerCell.viewWithTag(100) as UIDatePicker
            datePicker.setDate(self.date, animated: false)
        }
    }
    
    func hideDatePicker() {
        
        if self.datePickerVisible {
            
            self.datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 1)
            let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 1)
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    //table view methods
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .None
                
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 100
                datePicker.datePickerMode = UIDatePickerMode.Date
                cell.contentView.addSubview(datePicker)
                
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            }
            
            return cell
            
        } else {
            
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && self.datePickerVisible {
            
            return 2
            
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 0 {
            
            if !self.datePickerVisible {
                
                self.showDatePicker()
                
            } else {
                
                self.hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 0 || indexPath.section == 1 && indexPath.row == 0 || indexPath.section == 2 && indexPath.row == 0{
            
            return indexPath
            
        } else {
            
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }

    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customizeViewController()
    }
    
    //set delegate for CompanyTableViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCompany" {
            
            let controller = segue.destinationViewController as CompanyTableViewController
            
            controller.delegate = self
        }
    }
    
    //Company Table View Delegate Methods
    func companyViewController(controller: CompanyTableViewController, didFinishSelectingCompany item: TableItem) {
        
        self.companyDetailLabel.text = item.name
        
        self.companySelected = item
        
        self.checkIfFormIsComplete()
        
    }
    
    func companyViewControllerDidCancel(controller: CompanyTableViewController) {
        
    }
}
