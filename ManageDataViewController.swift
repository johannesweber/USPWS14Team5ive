//
//  ManageDataViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class ManageDataViewController: UITableViewController {

    var categories: [TableItem]
    
    required init(coder aDecoder: NSCoder) {
        
        self.categories = [TableItem]()
        
        let row0item = TableItem(text: "Fitness")
        categories.append(row0item)
        
        let row1item = TableItem(text: "Vitals")
        categories.append(row1item)
        
        let row2item = TableItem(text: "Nutrition")
        categories.append(row2item)
        
        let row3item = TableItem(text: "Sleep")
        categories.append(row3item)
        
        super.init(coder: aDecoder)
    }

    
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("ManageDataItem") as UITableViewCell
        let item = categories[indexPath.row]
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
            
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        var item = categories[indexPath.row]
        var category = item.text
        
        println(category)
            
        switch category {
            
        case "Fitness":
                self.performSegueWithIdentifier("goToFitness", sender: self)
        case "Vitals":
                self.performSegueWithIdentifier("goToVitals", sender: self)
        case "Nutrition":
                self.performSegueWithIdentifier("goToNutrition", sender: self)
        case "Sleep":
                self.performSegueWithIdentifier("goToSleep", sender: self)
        default:
            println("default (check ViewController tableView)")
        }
            tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
}
