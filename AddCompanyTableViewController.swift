//
//  AddDeviceViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData

class AddCompanyTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
        
        //Variables
        
        var companyPickerVisible = false
        var company: [CompanyItem]
        var companySelected: CompanyItem
    
        //variable for saving data into core data
        var managedObjectContext: NSManagedObjectContext!
    
        //initializer
        required init(coder aDecoder: NSCoder) {
            
            self.company = [CompanyItem]()
            self.companySelected = CompanyItem()
            
            let fitbit = CompanyItem(name: "Fitbit", nameInDatabase: "fitbit")
            self.company.append(fitbit)
            
            let medisana = CompanyItem(name: "Medisana", nameInDatabase: "medisana")
            self.company.append(medisana)
            
            let withings = CompanyItem(name: "Withings", nameInDatabase: "withings")
            self.company.append(withings)
            
            super.init(coder: aDecoder)
        }
        
        //IBOutlet
        @IBOutlet weak var cancelBarButton: UIBarButtonItem!
        @IBOutlet weak var addBarButton: UIBarButtonItem!
        
        //IBAction
        @IBAction func cancel(sender: UIBarButtonItem) {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //TODO disable done button if no company is added
        @IBAction func add(sender: UIBarButtonItem) {
            
            self.saveObjectToDatabase(self.companySelected)
            
            self.dismissViewControllerAnimated(true, completion: nil)
    
        }
        
        //methods
        
        func showCompanyPicker() {
            
            self.companyPickerVisible = true
            
            let indexPathCompanyPicker = NSIndexPath(forRow: 1, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPathCompanyPicker], withRowAnimation: .Fade)
            
            if let pickerCell = tableView.cellForRowAtIndexPath(indexPathCompanyPicker) {
                
                let companyPicker = pickerCell.viewWithTag(222) as UIPickerView
            }
        }
        
        func hideCompanyPicker() {
                    
            if self.companyPickerVisible {
            
                self.companyPickerVisible = false
                let indexPathCompanyRow = NSIndexPath(forRow: 0, inSection: 0)
                let indexPathCompanyPicker = NSIndexPath(forRow: 1, inSection: 0)
            
                tableView.beginUpdates()
                tableView.reloadRowsAtIndexPaths([indexPathCompanyRow], withRowAnimation: .None)
                tableView.deleteRowsAtIndexPaths([indexPathCompanyPicker], withRowAnimation: .Fade)
                tableView.endUpdates()
            
            }
        }

        
        //Picker View Methods
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            
            return 1
        }
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                
                return self.company.count
        }
        
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
                    
            return self.company[row].name
        }
        
        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                        
            self.companySelected = self.company[row]
            self.addBarButton.enabled = true
        }
        
        
        //Override Functions
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            self.tableView.rowHeight = 44
            
            self.showCompanyPicker()
            
            self.addBarButton.enabled = false
            
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
            if indexPath.section == 0 && indexPath.row == 1 {
            
                var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("CompanyPickerCell") as? UITableViewCell
            
                    if cell == nil {
                    
                        cell = UITableViewCell(style: .Default, reuseIdentifier: "CompanyPicker")
                        cell.selectionStyle = .None
                
                        let companyPicker = UIPickerView (frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                        companyPicker.tag = 222
                        companyPicker.dataSource = self
                        companyPicker.delegate = self
                        cell.contentView.addSubview(companyPicker)
                    }
            
                    return cell
            
            } else {
            
                return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            
            }
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
            if section == 0 && self.companyPickerVisible {
            
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
            
                if !self.companyPickerVisible {
                    
                    self.showCompanyPicker()
                    
                } else {
                    
                    self.hideCompanyPicker()
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
    
    func assignMeasurementsToCompany(company: CompanyItem) {
        
        switch company.name {
            
        case "Fitbit": self.createFitbitMeasurements(company)
        case "Withings": self.createWithingsMeasurements()
        case "Medisana": self.createMedisanaMeasurements()
        default: println("company not known")
            
        }
        
    }
    
    func createFitbitMeasurements(companyItem: CompanyItem) {
        
        var steps = MeasurementItem(name: NSLocalizedString("Steps", comment: "Name for Measurement Item Steps"), nameInDatabase: "steps", group: "Fitness")
        
        var duration = MeasurementItem(name: NSLocalizedString("Duration", comment: "Name for Measurement Item Duration"), nameInDatabase: "duration", group: "Fitness")
        
        var distance = MeasurementItem(name: NSLocalizedString("Distance", comment: "Name for Measurement Item Distance"), nameInDatabase: "distance", group: "Fitness")
        
        var caloriesBurned = MeasurementItem(name: NSLocalizedString("Calories Burned", comment: "Name for Measurement Item Calories Burned"), nameInDatabase: "caloriesOut", group: "Fitness")
        
        var elevation = MeasurementItem(name: NSLocalizedString("Elevation", comment: "Name for Measurement Item Elevation"), nameInDatabase: "elevation", group: "Fitness")
        
        var floors = MeasurementItem(name: NSLocalizedString("Floors", comment: "Name for Measurement Item Floors"), nameInDatabase: "floors", group: "Fitness")
        
        var bodyWeight = MeasurementItem(name: NSLocalizedString("Body Weight", comment: "Name for Measurement Item Body Weight"), nameInDatabase: "weight", group: "Vitals")
        
        var bodyHeight = MeasurementItem(name: NSLocalizedString("Body Height", comment: "Name for Measurement Item Body Height"), nameInDatabase: "height", group: "Vitals")
        
        var bmi = MeasurementItem(name: NSLocalizedString("BMI", comment: "Name for Measurement Item BMI"), nameInDatabase: "bmi", group: "Vitals")
        
        var bodyFat = MeasurementItem(name: NSLocalizedString("Body Fat", comment: "Name for Measurement Item Body Fat"), nameInDatabase: "bodyFat", group: "Vitals")
        
        var food = MeasurementItem(name: NSLocalizedString("Food", comment: "Name for Measurement Item Food"), nameInDatabase: "food", group: "Nutrition")
        
        var water = MeasurementItem(name: NSLocalizedString("Water", comment: "Name for Measurement Item Water"), nameInDatabase: "water", group: "Nutrition")
        
        var caloriesEaten = MeasurementItem(name: NSLocalizedString("Calories Eaten", comment: "Name for Measurement Item Calories Eaten"), nameInDatabase: "caloriesIn", group: "Nutrition")
        
        //TODO What to display in group sleep
        var sleepAnalysis = MeasurementItem(name: NSLocalizedString("Sleep Analysis", comment: "Name for Measurement Item Sleep Analysis"), nameInDatabase: "sleep", group: "Sleep")
        
        
        companyItem.measurements.append(steps)
        
        companyItem.measurements.append(duration)
        
        companyItem.measurements.append(distance)
        
        companyItem.measurements.append(caloriesBurned)
        
        companyItem.measurements.append(elevation)
        
        companyItem.measurements.append(floors)
        
        companyItem.measurements.append(bodyWeight)
        
        companyItem.measurements.append(bodyHeight)
        
        companyItem.measurements.append(bmi)
        
        companyItem.measurements.append(bodyFat)
        
        companyItem.measurements.append(food)
        
        companyItem.measurements.append(water)
        
        companyItem.measurements.append(caloriesEaten)
        
    }
    
    func createWithingsMeasurements() {
        
    }
    
    func createMedisanaMeasurements() {
        
    }

    
    func saveObjectToDatabase(companyItem: CompanyItem){
        
        let company = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: self.managedObjectContext) as Company
        
        company.name = companyItem.name
        company.nameInDatabase = companyItem.nameInDatabase
        company.color = companyItem.color
        company.checked = companyItem.checked
        company.measurements = companyItem.measurements
        
        var error: NSError?
        if !self.managedObjectContext.save(&error) {
            fatalCoreDataError(error)
            return
        }
    }

}
