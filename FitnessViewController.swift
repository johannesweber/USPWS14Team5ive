//
//  FitnessViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class FitnessViewController: UITableViewController {

    var measurements: [TableItem]
    
    var labelClicked: String
    
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [TableItem]()
        
        let row0item = TableItem(text: "Steps")
        measurements.append(row0item)
        
        let row1item = TableItem(text: "Duration")
        measurements.append(row1item)
        
        let row2item = TableItem(text: "Distance")
        measurements.append(row2item)
        
        let row3item = TableItem(text: "Calories burned")
        measurements.append(row3item)
        
        let row4item = TableItem(text: "Elevation")
        measurements.append(row4item)
        
        self.labelClicked = String()
        
        super.init(coder: aDecoder)
    }

    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FitnessItem") as UITableViewCell
            let item = measurements[indexPath.row]
            let label = cell.viewWithTag(1010) as UILabel
            label.text = item.text
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            return cell
    }
}
