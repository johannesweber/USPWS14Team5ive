//
//  FavCompanyTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 11.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class FavCompanyTableViewController: UITableViewController, CompanyTableViewControllerDelegate {
    
    //variables
    var allMeasurements = [Measurement]()
    var duplicateMeasurements = [Measurement]()
    var measurementSelected: Measurement!
    var companies = [Company]()
    var userId = prefs.integerForKey("USERID") as Int
    
    // variable for managing core data
    var managedObjectContext: NSManagedObjectContext!
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        self.allMeasurements = fetchMeasurementsFromCoreData()
        
        self.fetchDuplicateMeasurements()
        
        self.companies = fetchCompanyFromCoreData()

        
    }
    
    //table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.duplicateMeasurements.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MeasurementItem") as UITableViewCell
        let item = duplicateMeasurements[indexPath.row]
        
        let measurementLabel = cell.viewWithTag(100) as UILabel
        measurementLabel.text = item.name
        
        let favCompanyLabel = cell.viewWithTag(101) as UILabel
        favCompanyLabel.text = item.favoriteCompany
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedMeasurement = self.duplicateMeasurements[indexPath.row]
        
        self.showAlertToChooseCompany(selectedMeasurement)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    
    func fetchDuplicateMeasurements() {
        
        var url = "\(baseURL)/measurement/select/duplicate"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(self.userId)",
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                for (var x = 0; x < self.allMeasurements.count; x++ ) {
                    var measurement = self.allMeasurements[x]
                    
                    for(var y = 0; y < json.count; y++) {
                        
                        var duplicateMeasurementName = json[y]["nameInApp"].stringValue
                        
                        if duplicateMeasurementName == measurement.name {
                            
                            self.duplicateMeasurements.append(measurement)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.tableView.reloadData()
                    
                }
        }
    }
    
    //set delegate for CompanyTableViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCompany" {
            
            let companyTableViewController = segue.destinationViewController as CompanyTableViewController
            
            companyTableViewController.delegate = self
            companyTableViewController.measurementToEdit = self.measurementSelected
            
        }
    }
    
    //Company Table View Delegate Methods
    func companyViewController(controller: CompanyTableViewController, didFinishSelectingCompany item: Company) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func companyViewControllerDidCancel(controller: CompanyTableViewController) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showAlertToChooseCompany(measurement: Measurement){
        
        let alertController = UIAlertController(title: "Choose Company!\n", message: "Please choose your favorite Company", preferredStyle: .Alert)
        
        for (var x  = 0; x < self.companies.count; x++) {
            
            var favCompany = self.companies[x].name
            
            let companyAction = UIAlertAction(title: favCompany, style: .Default) { (_) in
                println("I Chose \(favCompany) for \(measurement.name)")
                self.updateMeasurement(measurement, favCompany: favCompany)
            }
            
            alertController.addAction(companyAction)
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            
        alertController.addAction(cancelAction)
            
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func updateMeasurement(measurement: Measurement, favCompany: String) {
            
        var batchRequest = NSBatchUpdateRequest(entityName: "Measurement")
        batchRequest.propertiesToUpdate = [ "favoriteCompany" : favCompany]
        batchRequest.resultType = .UpdatedObjectsCountResultType
        var error : NSError?
        
        var selectMeasurementPredicate = NSPredicate(format: "name = %@", measurement.name)
            
        batchRequest.predicate = selectMeasurementPredicate
        
        var results = self.managedObjectContext!.executeRequest(batchRequest, error: &error) as NSBatchUpdateResult
            
        self.fetchDuplicateMeasurements()
            
        self.tableView.reloadData()
    }
}




