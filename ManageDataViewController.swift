//
//  ManageDataViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import CoreData

/*
*
* This controller displays the categories. These categories are fetched from core data.
*
*/


//This is a protocol. A protocol is very similar to an interface in other languages. Every class that extends with an ManageDataViewControllerDelegate has to implement this method.
protocol ManageDataViewControllerDelegate: class {
    
    func manageDataViewController(controller: ManageDataViewController, didSelectCategory category: Category)
}

class ManageDataViewController: UITableViewController {

    //variables
    var categories =  [Category]()
    var selectedCategory: Category!
    
    //this variable is for "communicating" with other classes which implements the protocoll above
    weak var delegate: ManageDataViewControllerDelegate?

    override func viewDidLoad() {
        self.categories = fetchCategoriesFromCoreData()
    }
    
    //override methods
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
        
        self.selectedCategory = categories[indexPath.row]
        
        self.delegate?.manageDataViewController(self, didSelectCategory: self.selectedCategory)
        
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    //creating the delegate for ManageDataDetailViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToManageDataDetail" {
            
            let manageDataDetailViewController = segue.destinationViewController as ManageDataDetailViewController
            self.delegate = manageDataDetailViewController
            
        }
    }
}
