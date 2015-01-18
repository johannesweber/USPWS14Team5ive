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

/*
*
* This controller is for managing the dashboard. A user can add all his favorite measurements to the dashboard. Further the user is able
* to measurements to the dashboard. All Dashboard Items are stored in Core Data.
*
*/

class DashboardTableViewController: UITableViewController {
    
    //variables
    var userId = prefs.integerForKey("USERID") as Int
    var isLoading = false
    var request: Alamofire.Request?
    var companies = [Company]()
    
    // variable for managing core data
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Dashboard", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "Dashboards")
        
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
        
        self.companies = fetchCompanyFromCoreData()
        self.synchronizeData()
        
        self.tableView.reloadData()
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext!
        
        NSFetchedResultsController.deleteCacheWithName("Dashboards")

        self.companies = fetchCompanyFromCoreData()
        
        self.performFetch()
        
        self.showDashboardHelp()

    }
    
    override func viewDidDisappear(animated: Bool) {
        self.request?.cancel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        NSFetchedResultsController.deleteCacheWithName("Dashboards")
        
        self.performFetch()
        
        self.tableView.reloadData()
        
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
            let dashboard = self.fetchedResultsController.objectAtIndexPath(indexPath) as Dashboard
            
            let label = cell.viewWithTag(100) as UILabel
            let favCompanyLabel = cell.viewWithTag(101) as UILabel
            label.text = dashboard.text
            var favCompanyLabelText = NSLocalizedString("Company:", comment: "Text for cell in dashboard")
            favCompanyLabel.text = "\(favCompanyLabelText) \(dashboard.company)"
        
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            return cell
        }
    }
    
    //method will be executed if a cell is about to be deleted
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let goal = fetchedResultsController.objectAtIndexPath(indexPath) as Dashboard
            self.managedObjectContext.deleteObject(goal)
            
            var error: NSError?
            if !managedObjectContext.save(&error) {
                fatalCoreDataError(error)
            }
        }
    }
    
    //methods
    func performFetch() {
        var error: NSError?
        
        if !fetchedResultsController.performFetch(&error) {
            fatalCoreDataError(error)
        }
    }
    
    //this function synchronies the data from all companies from the user. At the end of the synchronization a popup informs the user that the data has been successfully synchronized.
    func synchronizeData(){
        
        self.isLoading = true
        self.tableView.reloadData()
        
        println("Companies Anzahl: \(self.companies.count)")
        
        var countCompanies = 0
        
        println("before request: \(countCompanies)")
        
        for (var x = 0; x < self.companies.count; x++) {
            
            var currentCompany = self.companies[x]
            
            if currentCompany.nameInDatabase != "focused health" {
                
                let url = "\(baseURL)/\(currentCompany.nameInDatabase)/synchronize/"
                
                println(url)
                
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
                        countCompanies++
                        
                        println("after request: \(countCompanies)")
                        
                        if countCompanies == self.companies.count {
                            self.isLoading = false
                            self.tableView.reloadData()
                            showAlert(NSLocalizedString("Sync Success!", comment: "Title for Message which appears if request successfully executed"), NSLocalizedString("Syncronization successfully executed", comment: "Message which appears if request successfully executed"), self)
                        }
                    }

                }
            
            } else {
                
                countCompanies = countCompanies + 1
            }
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
            let dashboard = controller.objectAtIndexPath(indexPath!) as Dashboard
            let label = cell.viewWithTag(100) as UILabel
            let favCompanyLabel = cell.viewWithTag(101) as UILabel
            label.text = dashboard.text
            var favCompanyLabelText = NSLocalizedString("Company:", comment: "Text for cell in dashboard")
            favCompanyLabel.text = "\(favCompanyLabelText) \(dashboard.company)"
            
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
    
    //this functions shows a little helper for newly registered users
    func showDashboardHelp() {
        
        let first = prefs.objectForKey("FIRSTTIMELOGIN") as String
        
        if first == "YES"{
            
            let dashboardHelp = prefs.objectForKey("DASHBOARDHELP") as String
            
            if dashboardHelp == "YES" {
                
                let title = NSLocalizedString("Hi! This is the Dashboard\n" ,comment: "Title for Dashboard Help")
                
                let message = NSLocalizedString("To Add a Measurement Click +\nTo Delete an added Measurement swipe to the left\nTo Synchronize Your Data Click the refresh Button" ,comment: "Messsage for Dashboard Help")
                
                showAlert(title, message, self)
            }
        }
        
        prefs.setValue("NO", forKey: "DASHBOARDHELP")
    }
}







