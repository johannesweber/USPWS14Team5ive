//
//  CompanyTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 03.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData

protocol CompanyTableViewControllerDelegate: class {
    
    func companyViewControllerDidCancel(controller: CompanyTableViewController)
    func companyViewController(controller: CompanyTableViewController, didFinishSelectingCompany item: Company)
    
}

class CompanyTableViewController: UITableViewController {

    //variables
    var companies = [Company]()
    var companySelected: Company!
    
    weak var delegate: CompanyTableViewControllerDelegate?
    
    var managedObjectContext: NSManagedObjectContext!
  
    //IBOUtlet
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    
    //IBAction
    @IBAction func save(sender: UIBarButtonItem) {
        
        self.delegate?.companyViewController(self, didFinishSelectingCompany: self.companySelected)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //override methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.companies = fetchCompanyFromCoreData()
        
        self.saveBarButton.enabled = false
    }
    
    //table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return companies.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyItem") as UITableViewCell
        let item = companies[indexPath.row]
        let label = cell.viewWithTag(1050) as UILabel
        label.text = item.name
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item = companies[indexPath.row]
        self.companySelected = item
        
        self.deselectAllCells()
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            if cell.accessoryType == .None {
                
                cell.accessoryType = .Checkmark
                item.checked = true
                self.saveBarButton.enabled = true
                
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func deselectAllCells() {
        
        for cell in self.tableView.visibleCells() as [UITableViewCell]{
            
            if cell.accessoryType == .Checkmark {
                
                cell.accessoryType = .None
            }
        }
    }
}
