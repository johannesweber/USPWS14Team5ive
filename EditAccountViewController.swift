//
//  EditAccountViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class EditAccountTableViewController: UITableViewController {

    //variables
    
    var editItems: [TableItem]
    
    
    //initialzer
    required init(coder aDecoder: NSCoder) {
        
        self.editItems = [TableItem]()
        
        let row0item = TableItem(name: "Change E - Mail")
        self.editItems.append(row0item)
        
        let row1item = TableItem(name: "Change - Password")
        self.editItems.append(row1item)
        
        let row2item = TableItem(name: "Set Favorite Company")
        self.editItems.append(row2item)
        
        super.init(coder: aDecoder)
    }

    //IBAction methods
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        
    }
    
    // override methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.editItems.count
    }
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("editAccountItem") as UITableViewCell
        let item = self.editItems[indexPath.row]
        let label = cell.viewWithTag(4020) as UILabel
        label.text = item.text
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        var item = self.editItems[indexPath.row]
        var category = item.text
        
        switch category {

        case "Change E - Mail":
            self.performSegueWithIdentifier("goToEmail", sender: self)
        case "Change - Password":
            self.performSegueWithIdentifier("goToPassword", sender: self)
        case "Set Favorite Company":
            self.performSegueWithIdentifier("goToFavCompany", sender: self)
        default:
            println("default (check ViewController tableView)")
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    
    
}
