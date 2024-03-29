 //
 //  AddToDashboardViewController.swift
 //  USPWS14Team5ive
 //
 //  Created by Johannes Weber on 30.11.14.
 //  Copyright (c) 2014 Johannes Weber. All rights reserved.
 //
 
 import UIKit
 import CoreData
 import Alamofire
 import SwiftyJSON
 
/*
*
* This controller is for managing the addtodashboard viewcontroller. Here a user can choose a measurement and add it to the dashboard.
* if the user clicked on Done Button the chosen measurement gets his "isInDashboard" property set to 1
*
*/
 
 class AddToDashboardTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Variables
    var measurementPickerVisible = true
    var measurements = [Measurement]()
    var measurementSelected: Measurement!
    var userId = prefs.integerForKey("USERID") as Int

    var managedObjectContext: NSManagedObjectContext!
    
    //IBOutlet
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var measurementDetailLabel: UILabel!
    
    //IBAction
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //TODO disable done button if no measurment is added
    @IBAction func done(sender: UIBarButtonItem) {
        
        //this method sets the "isInDashboard" property , in core data, to 1
        self.addMeasurementToDashboard(self.measurementSelected)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //Picker View Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.measurements.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.measurements[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.measurementSelected = self.measurements[row]
        self.measurementDetailLabel.text = self.measurementSelected.name
        self.doneBarButton.enabled = true

    }
    
    //methods
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
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        self.doneBarButton.enabled = false
        
        self.measurements = fetchMeasurementsFromCoreData()
        
    }
    
    //table view methods are methods to managing the content of tableviews
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("MeasurementPickerCell") as? UITableViewCell
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "MeasurementPicker")
                cell.selectionStyle = .None
                
                let datePicker = UIPickerView (frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 111
                datePicker.dataSource = self
                datePicker.delegate = self
                cell.contentView.addSubview(datePicker)
            }
            return cell
            
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
                
                self.showMeasurementPicker()
                
            } else {
                
                self.hideMeasurementPicker()
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
        

    
    //sets the text shown on dashboard for one measurement and than add it to dashboard
    func addMeasurementToDashboard(measurement: Measurement) {
        
        //variables needed for request
        var date = Date()
        var currentDate = date.getCurrentDateAsString() as String
        var url: String = "\(baseURL)/value/select"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "company"       : "\(measurement.favoriteCompany)",
            "endDate"       : "\(currentDate)",
            "limit"         : "1",
            "userId"        : "\(self.userId)",
            "measurement"   : "\(measurement.nameInDatabase)"
        ]
        
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(request)
                
                println(json)

                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    var value = json[0]["value"].doubleValue
                    var unit = json[0]["unit"].stringValue
                    var date = json[0]["DATE"].stringValue
                    
                    var text = "\(measurement.name): \(value) \(unit)"
                    
                    println(text)
                    
                    var dashboard = NSEntityDescription.insertNewObjectForEntityForName("Dashboard", inManagedObjectContext: self.managedObjectContext) as Dashboard
                    
                    var measurements = dashboard.measurement.allObjects as [Measurement]
                    measurements.append(measurement)
                    dashboard.company = measurement.favoriteCompany
                    dashboard.value = value
                    dashboard.unit = unit
                    dashboard.date = date
                    dashboard.text = text
                    
                    var error: NSError?
                    if self.managedObjectContext.save(&error) {
                        
                        println("dashboard successfully updated")
                        
                    } else {
                        
                        fatalCoreDataError(error)
                    }

                })
        }
        
    }

    
 }
