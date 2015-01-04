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
            
            case "Fitness"  : self.populateTableViewWithFitnessMeasurements()
            
            case "Vitals"   : self.populateTableViewWithVitalsMeasurements()
            
            case "Nutrition": self.populateTableViewWithNutritionMeasurements()
            
            case "Sleep"    : self.populateTableViewWithSleepMeasurements()
            
        default             : println("nothing selected")
            
        }
        
    }
    
    func populateTableViewWithFitnessMeasurements() {
        
        let row0item = MeasurementItem(name: "Steps", nameInDatabase: "steps")
        row0item.sliderLimit = 15000.0
        row0item.unit = "steps"
        measurements.append(row0item)
        
        let row1item = MeasurementItem(name: "Duration", nameInDatabase: "duration")
        measurements.append(row1item)
        
        let row2item = MeasurementItem(name: "Distance", nameInDatabase: "distance")
        measurements.append(row2item)
        
        let row3item = MeasurementItem(name: "Calories Burned", nameInDatabase: "caloriesOut")
        measurements.append(row3item)
        
        let row4item = MeasurementItem(name: "Elevation", nameInDatabase: "elevation")
        measurements.append(row4item)
    }
    
    func populateTableViewWithVitalsMeasurements() {
        
        let row0item = MeasurementItem(name: "Body Weight", nameInDatabase: "weight")
        measurements.append(row0item)
        
        let row1item = MeasurementItem(name: "Body Height", nameInDatabase: "height")
        measurements.append(row1item)
        
        let row2item = MeasurementItem(name: "BMI", nameInDatabase: "bmi")
        measurements.append(row2item)
        
        let row3item = MeasurementItem(name: "Body Fat", nameInDatabase: "bodyFat")
        measurements.append(row3item)
    }
    
    func populateTableViewWithNutritionMeasurements() {
    
        let row0item = MeasurementItem(name: "Food", nameInDatabase: "food")
        measurements.append(row0item)
        
        let row1item = MeasurementItem(name: "Water", nameInDatabase: "water")
        measurements.append(row1item)
        
        let row2item = MeasurementItem(name: "Calories Eaten", nameInDatabase: "caloriesIn")
        measurements.append(row2item)
    }
    
    func populateTableViewWithSleepMeasurements() {
        
        //TODO what to display here ?
        let row0item = MeasurementItem(name: "Sleep Analysis", nameInDatabase: "sleep")
        measurements.append(row0item)
    }
    
        
}
