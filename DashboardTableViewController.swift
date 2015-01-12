//
//  DashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class DashboardTableViewController: UITableViewController {
    
    //variables
    var userId = prefs.integerForKey("USERID") as Int
    var isLoading = false
    var request: Alamofire.Request?
    
    // variable for managing core data
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Measurement", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 20
        
        var isInDashboard = NSNumber(bool: true)
        
        var selectDashboardMeasurement = NSPredicate(format: "isInDashboard == %@", isInDashboard)
        
        fetchRequest.predicate = selectDashboardMeasurement
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Measurements")
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
        }()
    
    deinit {
        
        self.fetchedResultsController.delegate = nil
    }

    struct TableViewCellIdentifiers {
        
        static let loadingCell = "LoadingCell"
    }
    
    //IBAction
    @IBAction func refresh(sender: UIBarButtonItem) {
        
        self.isLoading = true
        self.tableView.reloadData()
        
        let url = "\(baseURL)/fitbit/synchronize/"
        
        let parameters: Dictionary<String, AnyObject> = [
            "userId"    : "\(self.userId)"
        ]
        
        //remove success message from user_info in php
        self.request = Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(json)
         
                var success = json["success"].intValue
                var message = json["message"].stringValue
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.isLoading = false
                    self.tableView.reloadData()
                }
                
                if success == 1 {
                    showAlert(NSLocalizedString("Success!", comment: "Title for Message which appears if request successfully executed"), NSLocalizedString("\(message)", comment: "Message which appears if request successfully executed"), self)
                }
                
        }
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        NSFetchedResultsController.deleteCacheWithName("Measurements")

        self.performFetch()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.request?.cancel()

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isLoading {
            
            return 1
            
        } else {
            
            let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        }
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.isLoading {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath:indexPath)
            as UITableViewCell
            let spinner = cell.viewWithTag(100) as UIActivityIndicatorView
            spinner.startAnimating()
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("DashboardItem") as UITableViewCell
            let measurement = self.fetchedResultsController.objectAtIndexPath(indexPath) as Measurement
            
            let label = cell.viewWithTag(100) as UILabel
            label.text = measurement.text
        
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            return cell
        }
    }
    
    //method will be executed if a cell is about to be deleted
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let measurement = fetchedResultsController.objectAtIndexPath(indexPath) as Measurement
            
            self.removeMeasurementFromDashboard(measurement)
        }
    }
    
    //methods
    func performFetch() {
        var error: NSError?
        
        if !fetchedResultsController.performFetch(&error) {
            fatalCoreDataError(error)
        }
    }
    
}

extension DashboardTableViewController: NSFetchedResultsControllerDelegate {
    
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
            let measurement = controller.objectAtIndexPath(indexPath!) as Measurement
            let label = cell.viewWithTag(100) as UILabel
            label.text = measurement.text
            
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
    
    // in this method we set the "isInDashboard" Property of a given measurement to "false". So it will disappear from dashboard
    func removeMeasurementFromDashboard(measurement: Measurement) {
        
        var batchRequest = NSBatchUpdateRequest(entityName: "Measurement")
        
        // i want to change the property "isInDashboard" to "false" or rather the variable "isInDashboard"
        var isInDashboard = NSNumber(bool: false)
        
        batchRequest.propertiesToUpdate = [ "isInDashboard" : isInDashboard]
        batchRequest.resultType = .UpdatedObjectsCountResultType
        var error : NSError?
        
        var selectMeasurementPredicate = NSPredicate(format: "name = %@", measurement.name)
        
        batchRequest.predicate = selectMeasurementPredicate
        
        var results = self.managedObjectContext!.executeRequest(batchRequest, error: &error) as NSBatchUpdateResult

        if !self.managedObjectContext.save(&error) {
            fatalCoreDataError(error)
        } else {
            println("Object successfully removed from Dashboard")
        }
    }
}







