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
    
    //TODO How to find out the "real" favorite Company ?
    func populateTableViewWithFitnessMeasurements() {
        
    }
    
    func populateTableViewWithVitalsMeasurements() {
        
    }
    
    func populateTableViewWithNutritionMeasurements() {
    
    }
    
    func populateTableViewWithSleepMeasurements() {
        
        //TODO what to display here ?
        
    }
    
        
}
