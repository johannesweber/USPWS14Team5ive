//
//  PeriodTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol PeriodTableViewControllerDelegate: class {
    
    func periodViewControllerDidCancel(controller: PeriodTableViewController)
    func periodViewController(controller: PeriodTableViewController, didFinishSelectingPeriod item: TableItem)
    
}

class PeriodTableViewController: UITableViewController {

    //variables
    var periods =  [TableItem]()
    var periodSelected = String()
    var currentFavoriteCompany = String()
    
    weak var delegate: PeriodTableViewControllerDelegate?
    
    //IBOutlets
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var safeBarButton: UIBarButtonItem!
    
    //IBAction
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.delegate?.periodViewControllerDidCancel(self)
    }
    
    @IBAction func safe(sender: UIBarButtonItem) {
        
        var newTableItem = TableItem(name: self.periodSelected)
        
        self.delegate?.periodViewController(self, didFinishSelectingPeriod: newTableItem)
    }
    
    //methods
    func populatePeriodTableView() {
        
        let daily = TableItem(name: NSLocalizedString("Daily", comment: "Name for Period Daily"), nameInDatabase: "daily")
        
        let weekly = TableItem(name:  NSLocalizedString("Weekly", comment: "Name for Period Weekly"), nameInDatabase: "weekly")
        
        let monthly = TableItem(name:  NSLocalizedString("Monthly", comment: "Name for Period Monthly"), nameInDatabase: "monthly")
        
        let annual = TableItem(name:  NSLocalizedString("Annual", comment: "Name for Period Annual"), nameInDatabase: "annual")
        
        self.periods.append(daily)
        self.periods.append(weekly)
        
        if self.currentFavoriteCompany != "fitbit" {
            
            self.periods.append(monthly)
            self.periods.append(annual)
        }
    }
    
    //override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populatePeriodTableView()
    }
    //table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return periods.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PeriodItem") as UITableViewCell
        let item = periods[indexPath.row]
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.name
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item = periods[indexPath.row]
        self.periodSelected = item.name
        
        self.deselectAllCells()
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            if cell.accessoryType == .None {
                
                cell.accessoryType = .Checkmark
                item.checked = true
                
            } else {
                
                cell.accessoryType = .None
                item.checked = false
                
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
