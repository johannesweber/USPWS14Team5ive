//
//  ManageDataDetailTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit

protocol ManageDataDetailViewControllerDelegate: class {
    
    func manageDataDetailViewController(controller: ManageDataDetailViewController, didSelectItem item: MeasurementItem)
}

class ManageDataDetailViewController: UITableViewController, ManageDataViewControllerDelegate {

    //variables
    var measurements: [MeasurementItem]
    var labelClicked: String
    var measurementSelected: MeasurementItem
    var currentMeasurement: MeasurementItem
    weak var delegate: ManageDataDetailViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [MeasurementItem]()
        self.measurementSelected = MeasurementItem()
        self.labelClicked = String()
        self.currentMeasurement = MeasurementItem()
        
        super.init(coder: aDecoder)
    }
    
    //override methods
    override func viewDidLoad() {
        
        self.title = self.currentMeasurement.name
        
        self.populateTableView(self.currentMeasurement)
    }
    
    //set delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToDiagram" {
            
            var destinationViewController = segue.destinationViewController as DiagramViewController
            self.delegate = destinationViewController
            
        }
    }
    
    //manage data view controller delegate methods
    func manageDataViewController(controller: ManageDataViewController, didSelectItem item: MeasurementItem) {
        
        self.currentMeasurement = item
        
    }
    
    //table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return measurements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ManageDataDetailItem") as UITableViewCell
        let item = measurements[indexPath.row]
        let label = cell.viewWithTag(1010) as UILabel
        label.text = item.name
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.measurementSelected = self.measurements[indexPath.row]
        
        self.delegate?.manageDataDetailViewController(self, didSelectItem: self.measurementSelected)
        
    }
    
    //methods
    
    func populateTableView(currentMeasurement: MeasurementItem){
        
        var currentMeasurementName = currentMeasurement.name
        
        switch currentMeasurementName {
            
            case NSLocalizedString("Fitness", comment: "Name for Manage Data Item Elevation in switch case statement")  : self.populateTableViewWithFitnessMeasurements()
            
            case NSLocalizedString("Vitals", comment: "Name for Manage Data Item Vitals in switch case statement")   : self.populateTableViewWithVitalsMeasurements()
            
            case NSLocalizedString("Nutrition", comment: "Name for Manage Data Item Nutrition in switch case statement"): self.populateTableViewWithNutritionMeasurements()
            
            case NSLocalizedString("Sleep", comment: "Name for Manage Data Item Sleep in switch case statement")    : self.populateTableViewWithSleepMeasurements()
            
        default             : println("nothing selected")
            
        }
        
    }
    
    func populateTableViewWithFitnessMeasurements() {
        
        let row0item = MeasurementItem(name: NSLocalizedString("Steps", comment: "Name for Measurement Item Steps"), nameInDatabase: "steps")
        row0item.sliderLimit = 15000.0
        row0item.unit = "steps"
        measurements.append(row0item)
        
        let row1item = MeasurementItem(name: NSLocalizedString("Duration", comment: "Name for Measurement Item Duration"), nameInDatabase: "duration")
        measurements.append(row1item)
        
        let row2item = MeasurementItem(name: NSLocalizedString("Distance", comment: "Name for Measurement Item Distance"), nameInDatabase: "distance")
        measurements.append(row2item)
        
        let row3item = MeasurementItem(name: NSLocalizedString("Calories Burned", comment: "Name for Measurement Item Calories Burned"), nameInDatabase: "caloriesOut")
        measurements.append(row3item)
        
        let row4item = MeasurementItem(name: NSLocalizedString("Elevation", comment: "Name for Measurement Item Elevation"), nameInDatabase: "elevation")
        measurements.append(row4item)
    }
    
    func populateTableViewWithVitalsMeasurements() {
        
        let row0item = MeasurementItem(name: NSLocalizedString("Body Weight", comment: "Name for Measurement Item Body Weight"), nameInDatabase: "weight")
        measurements.append(row0item)
        
        let row1item = MeasurementItem(name: NSLocalizedString("Body Height", comment: "Name for Measurement Item Body Height"), nameInDatabase: "height")
        measurements.append(row1item)
        
        let row2item = MeasurementItem(name: NSLocalizedString("BMI", comment: "Name for Measurement Item BMI"), nameInDatabase: "bmi")
        measurements.append(row2item)
        
        let row3item = MeasurementItem(name: NSLocalizedString("Body Fat", comment: "Name for Measurement Item Body Fat"), nameInDatabase: "bodyFat")
        measurements.append(row3item)
    }
    
    func populateTableViewWithNutritionMeasurements() {
    
        let row0item = MeasurementItem(name: NSLocalizedString("Food", comment: "Name for Measurement Item Food"), nameInDatabase: "food")
        measurements.append(row0item)
        
        let row1item = MeasurementItem(name: NSLocalizedString("Water", comment: "Name for Measurement Item Water"), nameInDatabase: "water")
        measurements.append(row1item)
        
        let row2item = MeasurementItem(name: NSLocalizedString("Calories Eaten", comment: "Name for Measurement Item Calories Eaten"), nameInDatabase: "caloriesIn")
        measurements.append(row2item)
    }
    
    func populateTableViewWithSleepMeasurements() {
        
        //TODO what to display here ?
        let row0item = MeasurementItem(name: NSLocalizedString("Sleep Analysis", comment: "Name for Measurement Item Sleep Analysis"), nameInDatabase: "sleep")
        measurements.append(row0item)
    }
    
        
}
