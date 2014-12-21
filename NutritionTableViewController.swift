//
//  NutritionTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit


class NutritionTableViewController: UITableViewController {

    var measurements: [TableItem]
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [TableItem]()
        
        let row0item = TableItem(name: "Food")
        measurements.append(row0item)
        
        let row1item = TableItem(name: "Water")
        measurements.append(row1item)
        
        let row2item = TableItem(name: "Calories eaten")
        measurements.append(row2item)
        
        super.init(coder: aDecoder)
    }

    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("NutritionItem") as UITableViewCell
            let item = measurements[indexPath.row]
            let label = cell.viewWithTag(1030) as UILabel
            label.text = item.name
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            return cell
    }
    
}
