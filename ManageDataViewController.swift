//
//  ManageDataViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol ManageDataViewControllerDelegate: class {
    
    func manageDataViewController(controller: ManageDataViewController, didSelectItem item: TableItem)
}

class ManageDataViewController: UITableViewController {

    //variables
    var categories: [TableItem]
    var selectedItem: TableItem
    weak var delegate: ManageDataViewControllerDelegate?
    
    //initializers
    required init(coder aDecoder: NSCoder) {
        
        self.categories = [TableItem]()
        self.selectedItem = TableItem()
        
        let row0item = TableItem(name: "Fitness")
        categories.append(row0item)
        
        let row1item = TableItem(name: "Vitals")
        categories.append(row1item)
        
        let row2item = TableItem(name: "Nutrition")
        categories.append(row2item)
        
        let row3item = TableItem(name: "Sleep")
        categories.append(row3item)
        
        super.init(coder: aDecoder)
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("ManageDataItem") as UITableViewCell
        let item = categories[indexPath.row]
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.name
            
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        self.selectedItem = categories[indexPath.row]
        
        self.delegate?.manageDataViewController(self, didSelectItem: self.selectedItem)
        
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    //creating the delegate for ManageDataDetailViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToManageDataDetail" {
            
            let destinationViewController = segue.destinationViewController as ManageDataDetailViewController
            self.delegate = destinationViewController
            
        }
    }
}
