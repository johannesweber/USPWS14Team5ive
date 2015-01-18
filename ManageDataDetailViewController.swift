//
//  ManageDataDetailTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData

/*
*
* This controller displays the measurements belonging to a the clicked measurement.
* If the user clicked on a measurement he/she will be forwarded to the Diagram View.
*
*/

class ManageDataDetailViewController: UITableViewController, ManageDataViewControllerDelegate {

    //variables
    var labelClicked = String()
    var selectedCategory: Category!
    
    // variable for managing core data
    var managedObjectContext: NSManagedObjectContext!
    
    //this fetched results Controller contains the Measurements fetched from core data. With a predicate this controller is able to fetch only those measurements belonging to the clicked category
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Measurement", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 20
        
        // A Predicate is for selecting a specific entity. A predicate is comparable with the WHERE statement in MySQL
        var selectCategoryPredicate = self.getPredicateAccordingToCurrentLanguage(self.selectedCategory.name)
        
        fetchRequest.predicate = selectCategoryPredicate
        
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
        fetchedResultsController.delegate = nil
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        self.title = self.selectedCategory.name
        
        NSFetchedResultsController.deleteCacheWithName("Measurements")
        
        self.performFetch()
        
    }
    
    
    //sets the delegate and passes the selected measurement forward to DiagramViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToDiagram" {
            
            var diagramViewController = segue.destinationViewController as DiagramViewController
            
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                let measurement = self.fetchedResultsController.objectAtIndexPath(indexPath) as Measurement
                
                diagramViewController.currentMeasurement = measurement
            }
        
        }
    }
    
    //manage data view controller delegate methods
    func manageDataViewController(controller: ManageDataViewController, didSelectCategory category: Category) {
        
        self.selectedCategory = category
        
    }
    
    //table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
        
    }
    
    //this method sets the text for the label shown in table cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ManageDataDetailItem") as UITableViewCell
        let measurement = self.fetchedResultsController.objectAtIndexPath(indexPath) as Measurement
        let label = cell.viewWithTag(1010) as UILabel
        
        var currentLanguage = NSLocale.currentLanguageString
        
        //depending on the current language the text of the shown label is different **work in progress**
        switch currentLanguage {
        case "en" : label.text = measurement.name
        case "de" : label.text = measurement.name
        case "fr" : label.text = measurement.name
        default : println("language unknown")
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    //methods
    func performFetch() {
        var error: NSError?
        
        if !fetchedResultsController.performFetch(&error) {
            fatalCoreDataError(error)
        }
    }
    
    //sets the predicate for the fetch from core data. A fetch is someting like the WHERE Keyword in MySQL
    //depending on the language of the current device the predicate is for a different groupname
    func getPredicateAccordingToCurrentLanguage(categoryName: String) -> NSPredicate{
        
        var predicate = String()
        
        var currentLanguage = NSLocale.currentLanguageString
        
        //depending on the current language the the used predicate is different **work in progress**
        
        switch currentLanguage {
            case "en": predicate = "groupname"
            case "de": predicate = "groupname"
            case "fr": predicate = "groupname"
        default: println("Language not known")
            
        }
        
        var selectCategoryPredicate = NSPredicate(format: "\(predicate) = %@", categoryName)
        
        return selectCategoryPredicate!
    }
}

//delegate methods for the fetchedresultscontroller. These methods are called everytime the measurements in core data have changed
extension ManageDataDetailViewController: NSFetchedResultsControllerDelegate {
            
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
            let label = cell.viewWithTag(1010) as UILabel
        
            var currentLanguage = NSLocale.currentLanguageString
        
            switch currentLanguage {
            case "en" : label.text = measurement.name
            case "de" : label.text = measurement.name
            case "fr" : label.text = measurement.name
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








