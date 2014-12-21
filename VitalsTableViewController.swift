//
//  VitalsViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit


class VitalsTableViewController: UITableViewController {

    var measurements: [TableItem]
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [TableItem]()
        
        let row0item = TableItem(name: "Body Weight")
        measurements.append(row0item)
        
        let row1item = TableItem(name: "Body Height")
        measurements.append(row1item)
        
        let row2item = TableItem(name: "BMI")
        measurements.append(row2item)
        
        let row3item = TableItem(name: "Body Fat")
        measurements.append(row3item)
        
        let row4item = TableItem(name: "Blood Pressure")
        measurements.append(row4item)
        
        let row5item = TableItem(name: "Heart Rate")
        measurements.append(row5item)
        
        let row6item = TableItem(name: "Glucose")
        measurements.append(row6item)
        
        super.init(coder: aDecoder)
    }

    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("VitalsItem") as UITableViewCell
            let item = measurements[indexPath.row]
            let label = cell.viewWithTag(1020) as UILabel
            label.text = item.name
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            return cell
    }
}
