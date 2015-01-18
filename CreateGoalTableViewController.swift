//
//  CreateGoalTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

/*
*
* This controller is for creating a new goal. 
*
*/

class CreateGoalTableViewController: UITableViewController, PeriodTableViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    //variables
    var startdate =  NSDate()
    var startDatePickerVisible = false
    var measurementPickerVisible = false
    var measurements = [Measurement]()
    var measurementSelected: Measurement!
    var userId = prefs.integerForKey("USERID") as Int
    // variable for managing core data
    var managedObjectContext: NSManagedObjectContext!
    
    //IBOutlet
    @IBOutlet weak var valueSlider: UISlider!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var measurementDetailLabel: UILabel!
    @IBOutlet weak var periodDetailLabel: UILabel!
    @IBOutlet weak var startDateDetailLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var targetValueTextField: UITextField!
    
    //IBAction
    //this method is called if the user presses on the save button. in this method a connection to core data is established and the new goal will be iunserted.
    @IBAction func save(sender: UIBarButtonItem) {
        
        var goal = NSEntityDescription.insertNewObjectForEntityForName("Goal", inManagedObjectContext: self.managedObjectContext) as Goal
        
        goal.measurement = self.measurementSelected.nameInDatabase
        goal.period = self.convertPeriod(self.periodDetailLabel.text!)
        goal.startdate = self.startDateDetailLabel.text!
        goal.company = self.measurementSelected.favoriteCompany
        goal.targetValue = self.targetValueTextField.text.toInt()!
        goal.unit = self.unitLabel.text!
        goal.userId = self.userId
        
        //default values for current value and text
        goal.text = "(nothing to show)"
        goal.currentValue = 0

        
        var error: NSError?
        if self.managedObjectContext.save(&error) {
            
            self.insertGoalIntoDatabase(goal)
            
            self.createTextForGoal(goal)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            fatalCoreDataError(error)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.targetValueTextField.delegate = self
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        self.saveBarButton.enabled = false
        self.targetValueTextField.enabled = false
        self.unitLabel.textColor = UIColor.grayColor()
        
        self.measurements = fetchGoalableMeasurementsFromCoreData()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.targetValueTextField.resignFirstResponder()
        
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
        
        var itemSelected = self.measurements[row]
        
        self.measurementDetailLabel.text = itemSelected.name
        
        self.measurementSelected = itemSelected
        
        self.unitLabel.text = itemSelected.unit
        self.unitLabel.textColor = UIColor.blackColor()
        self.targetValueTextField.enabled = true
        
        self.checkIfFormIsComplete()
    }
    
    //methods
    func createTextForGoal(goal: Goal) {
        
        //variables needed for request
        var url: String = "\(baseURL)/goals/select/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(self.userId)",
            "measurement"   : "\(goal.measurement)",
            "period"        : "\(goal.period)",
            "company"       : "\(goal.company)",
            "startDate"     : "\(self.startDateDetailLabel.text!)",
            "limit"         : "1"
        ]
        
        //wrong user ID stored in Database
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(request)
                
                println(json)
                
                var currentValue = json[0]["currentValue"].intValue
                var targetValue = json[0]["goalValue"].intValue
                var text = "\(goal.measurement): \(currentValue) \(goal.unit)"
                
                println(currentValue)
                println(targetValue)
                println(text)
                    
                self.updateGoal(goal, property: "currentValue", newValue: currentValue)
                self.updateGoal(goal, property: "text", newValue: text)
                self.updateGoal(goal, property: "targetValue", newValue: targetValue)
                
                if json[0] == nil {
                    
                    var title = NSLocalizedString("No Values available", comment: "title if no values available for created goal")
                    
                    var message = NSLocalizedString("Till now you dont have any values archived fot this goal, wether this date for the goal is in the future or you have to archive no values", comment: "message if no values available for created goal")
                    
                    showAlert(title, message, self)
                }

                
                
                
        }
    }
    
    func updateGoal(goal: Goal, property: String, newValue: AnyObject) -> Bool{
        
        var success = false
        
        var batchRequest = NSBatchUpdateRequest(entityName: "Goal")
        batchRequest.propertiesToUpdate = [ property : newValue]
        batchRequest.resultType = .UpdatedObjectsCountResultType
        var error : NSError?
        
        // A Predicate is for selecting a specific entity. A predicate is comparable with the WHERE statement in MySQL
        var selectMeasurementPredicate = NSPredicate(format: "measurement = %@", goal.measurement)
        
        var selectPeriodPredicate = NSPredicate(format: "period = %@", goal.period)
        
        // a NSCompoundPredicate is used for combine two ore more predicates
        var compoundPredicate = NSCompoundPredicate.andPredicateWithSubpredicates([selectMeasurementPredicate!, selectPeriodPredicate!])
        
        batchRequest.predicate = compoundPredicate
        
        var results = self.managedObjectContext!.executeRequest(batchRequest, error: &error) as NSBatchUpdateResult
        
        if self.managedObjectContext.save(&error) {
            
            println("Goal for \(goal.measurement) successfully updated")
            
            success = true
            
        } else {
            
            fatalCoreDataError(error)
        }
        
        return success

    }


    func insertGoalIntoDatabase(goal: Goal) {
        
        var url = "\(baseURL)/goals/insert/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(self.userId)",
            "measurement"   : "\(goal.measurement)",
            "period"        : "\(goal.period)",
            "startDate"     : "\(goal.startdate)",
            "company"       : "\(goal.company)",
            "goalValue"     : "\(goal.targetValue)"
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseString { (request, response, json, error) in
                
                println(request)
                
                println(json)
        }
    }
    
    //this methods convert the given period to the appropriate period name in our database
    func convertPeriod(period: String) -> String{
    
        var periodNameInDatabase = String()
        
        switch period {
            case "Daily", "Täglich", "Journalier": periodNameInDatabase = "daily"
            case "Weekly", "Wöchentlich", "Hedomadaire": periodNameInDatabase = "weekly"
            case "Monthly", "Monatlich", "Mensuel": periodNameInDatabase = "monthly"
            case "Annual", "Jährlich", "Annuel": periodNameInDatabase = "annual"
        default: println("period not known")
        }
        
        return periodNameInDatabase
    }
    
    func checkIfFormIsComplete() {
        
        if measurementDetailLabel.text != "Detail" && periodDetailLabel.text != "Detail" && startDateDetailLabel.text != "Detail" && self.targetValueTextField.text != "" {
            
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
        
            if !self.startDatePickerVisible {
        
                self.showStartDatePicker()
        
            } else {
        
                self.hideStartDatePicker()
            }
            
        } else if indexPath.section == 0 && indexPath.row == 0 {
            
            if !self.measurementPickerVisible {
            
                self.showMeasurementPicker()
                
            } else {
                
                self.hideMeasurementPicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
        if indexPath.section == 0 && indexPath.row == 0 || indexPath.section == 1 && indexPath.row == 0 || indexPath.section == 1 && indexPath.row == 1 || indexPath.section == 2 && indexPath.row == 0 {
            
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
            
            let periodTableViewController = segue.destinationViewController as PeriodTableViewController
            
            periodTableViewController.delegate = self
            periodTableViewController.currentFavoriteCompany = self.measurementSelected.favoriteCompany
            
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
