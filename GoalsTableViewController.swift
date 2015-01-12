//
//  GoalsTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class GoalsTableViewController: UITableViewController {
    
    //variables
    var userId = prefs.integerForKey("USERID") as Int
    //variables
    // variable for managing core data
    var managedObjectContext: NSManagedObjectContext!
    
    //this variable contains all company items fetched from core data
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Goal", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "measurement", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Goals")
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
        }()
    
    deinit {
        self.fetchedResultsController.delegate = nil
    }
    
    //IBAction
    @IBAction func refresh(sender: UIBarButtonItem) {
        //Need to write a method for refreshing all goal items shown in table view
    
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        NSFetchedResultsController.deleteCacheWithName("Measurements")
        
        self.performFetch()
    }

    
    //methods
    func performFetch() {
        var error: NSError?
        if !fetchedResultsController.performFetch(&error) {
            fatalCoreDataError(error)
        }
    }
    
    //TODO need to rewrite insert and select goals
    func fetchValueFromGoal(goal: Goal) {
        
        //variables needed for request
        var url: String = "\(baseURL)/goals/select/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(self.userId)",
            "measurement"   : "\(goal.measurement)",
            "period"        : "\(goal.convertPeriodToInt())",
            "company"       : "\(goal.company)",
            "limit"         : "1"
        ]
        
        //wrong user ID stored in Database
        Alamofire.request(.GET, url, parameters: parameters)
            .responseString { (request, response, json, error) in
                
                println(request)
                
                println(json)
                
//                var currentValue = json[0]["current_value"].intValue
//                var targetValue = json[0]["target_value"].intValue
//                
//                goal.progressValue = currentValue
//                
//                var text = "\(goal.measurement): \(currentValue)"
//                
//                goal.text = text
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.tableView!.reloadData()
//                })
        }
    
    }
    
    //override methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.fetchValueFromGoal(self.fetchedResultsController.objectAtIndexPath(indexPath) as Goal)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        
        return sectionInfo.numberOfObjects
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalItem") as UITableViewCell
        let item: Goal = self.fetchedResultsController.objectAtIndexPath(indexPath) as Goal
        let label = cell.viewWithTag(3010) as UILabel
        let progressView = cell.viewWithTag(555) as UIProgressView
        
        let fractionalProgress = Float(item.progressValue) / Float(item.value)
        progressView.setProgress(fractionalProgress, animated: true)
        label.text = item.measurement
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    //method will be executed if a cell is about to be deleted
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let location = fetchedResultsController.objectAtIndexPath(indexPath) as Company
            self.managedObjectContext.deleteObject(location)
            
            var error: NSError?
            if !managedObjectContext.save(&error) {
                fatalCoreDataError(error)
            }
        }
    }

}

extension GoalsTableViewController: NSFetchedResultsControllerDelegate {
            
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
            let goal = controller.objectAtIndexPath(indexPath!) as Goal
            let label = cell.viewWithTag(3010) as UILabel
        
            var currentLanguage = NSLocale.currentLanguageString
        
            switch currentLanguage {
            case "en" : label.text = goal.measurement
            case "de" : label.text = goal.measurement
            case "fr" : label.text = goal.measurement
            default : println("language unknown")
        
    }
    
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

    

