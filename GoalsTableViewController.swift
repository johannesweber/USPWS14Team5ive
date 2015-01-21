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

/*
*
* This controller displays the user's goals. From Here he/she can add a goal or create a new one.
*
*/

class GoalsTableViewController: UITableViewController {
    
    //variables
    var userId = prefs.integerForKey("USERID") as Int

    // variable for managing core data
    var managedObjectContext: NSManagedObjectContext!
    
    //this variable contains all goal items fetched from core data.
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        //TODO why crashes the app if clicking on logout ? **work in progress**
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
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        NSFetchedResultsController.deleteCacheWithName("Goals")
        
        self.performFetch()
        
        self.tableView.reloadData()
        
        self.showGoalHelp()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSFetchedResultsController.deleteCacheWithName("Goals")
        
        self.performFetch()
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    //methods
    //if this method is called the fetchedresultscontroller gets filled with data in core data
    func performFetch() {
        var error: NSError?
        if !fetchedResultsController.performFetch(&error) {
            fatalCoreDataError(error)
        }
    }

    //override methods
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
        
        let progress = Float(item.currentValue) / Float(item.targetValue)
        progressView.setProgress(progress, animated: true)
        label.text = item.text
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    //method will be executed if a cell is about to be deleted
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let goal = fetchedResultsController.objectAtIndexPath(indexPath) as Goal
            self.managedObjectContext.deleteObject(goal)
            
            var error: NSError?
            if !managedObjectContext.save(&error) {
                fatalCoreDataError(error)
            }
        }
    }
    
    //this functions shows a little helper for newly registered users
    func showGoalHelp() {
        
        let first = prefs.objectForKey("FIRSTTIMELOGIN") as String
        
        if first == "YES"{
            
            println(first)
            
            let goalHelp = prefs.objectForKey("GOALHELP") as String
            
            println(goalHelp)
            
            if goalHelp == "YES" {
                
                let title = NSLocalizedString("Hi! Here you can add and create new Goals\n" ,comment: "Title for Goal Help")
                
                let message = NSLocalizedString("To Add a Goal Click +\nTo Delete an added Goal swipe to the left\n" ,comment: "Messsage for Goal Help")
                
                showAlert(title, message, self)
            }
        }
        
        prefs.setValue("NO", forKey: "GOALHELP")
    }

}

//delegate methods for the fetchedresultscontroller. These methods are called everytime the goal in core data have changed
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
            let progressView = cell.viewWithTag(555) as UIProgressView
        
            let progress = Float(goal.currentValue) / Float(goal.targetValue)
            progressView.setProgress(progress, animated: true)
            
            var currentLanguage = NSLocale.currentLanguageString
        
            switch currentLanguage {
            case "en" : label.text = goal.text
            case "de" : label.text = goal.text
            case "fr" : label.text = goal.text
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

    

