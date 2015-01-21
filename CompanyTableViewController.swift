//
//  CompanyTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 03.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData

//This is a protocol. A protocol is very similar to an interface in other languages. Every class that extends with an ComapnyTableViewControllerDelegate has to implement these two methods.
protocol CompanyTableViewControllerDelegate: class {
    
    func companyViewControllerDidCancel(controller: CompanyTableViewController)
    func companyViewController(controller: CompanyTableViewController, didFinishSelectingCompany item: Company)
    
}

class CompanyTableViewController: UITableViewController {

    //variables
    var companies = [Company]()
    var companySelected: Company!
    var measurementToEdit: Measurement?
    
    //this variable is for "communicating" with other classes which implements the CompanyTableViewControllerDelegate protocol
    weak var delegate: CompanyTableViewControllerDelegate?
  
    //IBOUtlet
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    
    //IBAction
    @IBAction func save(sender: UIBarButtonItem) {
        
        self.delegate?.companyViewController(self, didFinishSelectingCompany: self.companySelected)
    
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.delegate?.companyViewControllerDidCancel(self)
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
        
        //go through all cells in the table view and remove the checkmark
        for cell in self.tableView.visibleCells() as [UITableViewCell]{
            
            if cell.accessoryType == .Checkmark {
                
                cell.accessoryType = .None
            }
        }
    }
}
