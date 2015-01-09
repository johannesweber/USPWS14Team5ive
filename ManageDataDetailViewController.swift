//
//  ManageDataDetailTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData

protocol ManageDataDetailViewControllerDelegate: class {
    
    func manageDataDetailViewController(controller: ManageDataDetailViewController, didSelectItem item: Measurement)
}

class ManageDataDetailViewController: UITableViewController, ManageDataViewControllerDelegate {

    //variables
    var measurements: [Measurement]
    var labelClicked: String
    var currentMeasurement: MeasurementItem
    
    weak var delegate: ManageDataDetailViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [Measurement]()
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
        
        var currentLanguage = NSLocale.currentLanguageString
        
        //need to safe german names for measurements in fh database
        switch currentLanguage {
        case "en" : label.text = item.name
        case "de" : label.text = item.name
        default : println("language unknown")
            
        }
        

        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    //methods
    //method to fill the table view with measurements from core data
    func populateTableView(groupSelected: MeasurementItem){
        
        var groupName = groupSelected.name
        
        var currentLanguage = NSLocale.currentLanguageString
        
        var measurementArray = self.fetchMeasurementFromCoreData()
        
        for meas in measurementArray {
            
            var measurement = meas as Measurement
            
            switch currentLanguage {
            case "de": if measurement.groupnameInGerman == groupName {
                
                            self.measurements.append(measurement)
                        }
            case "en":  if measurement.groupname == groupName {
                
                            self.measurements.append(measurement)
                        }

            default: println("language unknown")
                
            }
        }
    }
    
    func fetchMeasurementFromCoreData() -> NSArray{
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Measurement")
        request.returnsObjectsAsFaults = false
        
        //TODO add error handling
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        return results
    }
    
    
}
