//
//  ManageDataDetailTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit

protocol ManageDataDetailViewControllerDelegate: class {
    
    func manageDataDetailViewController(controller: ManageDataDetailViewController, didSelectItem item: TableItem)
}

class ManageDataDetailViewController: UITableViewController, ManageDataViewControllerDelegate {

    //variables
    var measurements: [TableItem]
    var labelClicked: String
    var measurementSelected: TableItem
    var currentMeasurement: TableItem
    weak var delegate: ManageDataDetailViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [TableItem]()
        self.measurementSelected = TableItem()
        self.labelClicked = String()
        self.currentMeasurement = TableItem()
        
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
    func manageDataViewController(controller: ManageDataViewController, didSelectItem item: TableItem) {
        
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
    
    func populateTableView(currentMeasurement: TableItem){
        
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
        
        let row0item = TableItem(name: "Steps", nameInDatabase: "steps")
        measurements.append(row0item)
        
        let row1item = TableItem(name: "Duration", nameInDatabase: "duration")
        measurements.append(row1item)
        
        let row2item = TableItem(name: "Distance", nameInDatabase: "distance")
        measurements.append(row2item)
        
        let row3item = TableItem(name: "Calories Burned", nameInDatabase: "caloriesOut")
        measurements.append(row3item)
        
        let row4item = TableItem(name: "Elevation", nameInDatabase: "elevation")
        measurements.append(row4item)
    }
    
    func populateTableViewWithVitalsMeasurements() {
        
        let row0item = TableItem(name: "Body Weight", nameInDatabase: "weight")
        measurements.append(row0item)
        
        let row1item = TableItem(name: "Body Height", nameInDatabase: "height")
        measurements.append(row1item)
        
        let row2item = TableItem(name: "BMI", nameInDatabase: "bmi")
        measurements.append(row2item)
        
        let row3item = TableItem(name: "Body Fat", nameInDatabase: "bodyFat")
        measurements.append(row3item)
    }
    
    func populateTableViewWithNutritionMeasurements() {
    
        let row0item = TableItem(name: "Food", nameInDatabase: "food")
        measurements.append(row0item)
        
        let row1item = TableItem(name: "Water", nameInDatabase: "water")
        measurements.append(row1item)
        
        let row2item = TableItem(name: "Calories Eaten", nameInDatabase: "caloriesIn")
        measurements.append(row2item)
    }
    
    func populateTableViewWithSleepMeasurements() {
        
        //TODO what to display here ?
        let row0item = TableItem(name: "Sleep Analysis", nameInDatabase: "sleep")
        measurements.append(row0item)
    }
    
        
}
