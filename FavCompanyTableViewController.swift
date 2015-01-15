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

class FavCompanyTableViewController: UITableViewController {
    
    //variables
    var userId = prefs.integerForKey("USERID") as Int
    
    //object for managing duplicate measurements
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Measurement", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var isDuplicate = NSNumber(bool: true)
        
        let selectDuplicatePredicate = NSPredicate(format: "isDuplicate == %@", isDuplicate)
        
        fetchRequest.predicate = selectDuplicatePredicate
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Measurements")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
        }()
    
    deinit {
        
        fetchedResultsController.delegate = nil
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        NSFetchedResultsController.deleteCacheWithName("Measurements")
        
        self.performFetch()
        
        self.tableView.reloadData()

    }
    
    func performFetch() {
        var error: NSError?
        if !fetchedResultsController.performFetch(&error) {
            
            fatalCoreDataError(error)
            
        }
    }
    
    //table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MeasurementItem") as UITableViewCell
        let duplicateMeasurement = self.fetchedResultsController.objectAtIndexPath(indexPath) as Measurement
        
        let measurementLabel = cell.viewWithTag(100) as UILabel
        measurementLabel.text = duplicateMeasurement.name
        
        let favCompanyLabel = cell.viewWithTag(101) as UILabel
        var favCompanyLabelText = NSLocalizedString("Company:", comment: "Text for cell in favorite company")
        favCompanyLabel.text = "\(favCompanyLabelText) \(duplicateMeasurement.favoriteCompany)"
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.showAlertToChooseCompany(self.fetchedResultsController.objectAtIndexPath(indexPath) as Measurement)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    func showAlertToChooseCompany(measurement: Measurement){
        
        var title = NSLocalizedString("Choose Company!\n", comment: "This is the title for the message if the user has to choose a favorite company")
        var message = NSLocalizedString("Please choose your favorite Company", comment: "This is the message if the user has to choose a favorite company")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

        var companies:[String] = self.fetchCompanyMeasurement(measurement)
    
        for company in companies {
        
            let companyAction = UIAlertAction(title: company, style: .Default) { action -> Void in
            
                var success = updateOneMeasurement(measurement.name, "favoriteCompany", company)
                
                NSFetchedResultsController.deleteCacheWithName("Measurements")
                
                self.performFetch()
                
                self.tableView.reloadData()
        
            }
        
            alertController.addAction(companyAction)
        }
    
        var cancelTitle = NSLocalizedString("Cancel", comment: "This is the title for the cancel button")
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel) { (_) in }
            
        alertController.addAction(cancelAction)
    
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //fetches the companies of the given measurement an stores them in a string array
    func fetchCompanyMeasurement(measurement: Measurement) -> [String] {
        
        var companies = [String]()
        
        var companyHasMeasurement: [CompanyHasMeasurement] = fetchCompanyHasMeasurement(measurement)
        
        for elem in companyHasMeasurement {
            
            companies.append(elem.company)
        }
        
        return companies
        
    }
}


extension FavCompanyTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
    println("*** controllerWillChangeContent")
    tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
    case .Insert:
        println("*** NSFetchedResultsChangeInsert (object)")
        tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        
    case .Delete:
            println("*** NSFetchedResultsChangeDelete (object)")
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        
    case .Update:
            println("*** NSFetchedResultsChangeUpdate (object)")
        let cell = tableView.cellForRowAtIndexPath(indexPath!)!
        let duplicateMeasurement = controller.objectAtIndexPath(indexPath!) as Measurement
        
        let measurementLabel = cell.viewWithTag(100) as UILabel
        measurementLabel.text = duplicateMeasurement.name
        
        let favCompanyLabel = cell.viewWithTag(101) as UILabel
        var favCompanyLabelText = NSLocalizedString("Company:", comment: "Text for cell in favorite company")
        favCompanyLabel.text = "\(favCompanyLabelText) \(duplicateMeasurement.favoriteCompany)"
        
        
    case .Move:
            println("*** NSFetchedResultsChangeMove (object)")
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
    case .Insert:
        println("*** NSFetchedResultsChangeInsert (section)")
        tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        
    case .Delete:
            println("*** NSFetchedResultsChangeDelete (section)")
        tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        
    case .Update:
            println("*** NSFetchedResultsChangeUpdate (section)")
        
    case .Move:
                println("*** NSFetchedResultsChangeMove (section)")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        println("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}





