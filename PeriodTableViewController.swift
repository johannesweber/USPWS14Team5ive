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
    var periods: [TableItem]
    var periodSelected: String
    
    weak var delegate: PeriodTableViewControllerDelegate?
    
    //IBOutlets
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //IBAction
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.delegate?.periodViewControllerDidCancel(self)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
    
        var newTableItem = TableItem(name: self.periodSelected)
        
        self.delegate?.periodViewController(self, didFinishSelectingPeriod: newTableItem)
    }
    
    //Initializer
    required init(coder aDecoder: NSCoder) {
        
        self.periods = [TableItem]()
        self.periodSelected = String()
        
        let row0item = TableItem(name: "Daily")
        periods.append(row0item)
        
        let row1item = TableItem(name: "Weekly")
        periods.append(row1item)
        
        let row2item = TableItem(name: "Monthly")
        periods.append(row2item)
        
        let row3item = TableItem(name: "Annual")
        periods.append(row3item)
        
        super.init(coder: aDecoder)
    }
    
    
    
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
        
        println(self.periodSelected)
    }

    
}
