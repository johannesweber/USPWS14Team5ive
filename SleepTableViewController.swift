//
//  SleepTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit


class SleepTableViewController: UITableViewController {

    var measurements: [TableItem]
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [TableItem]()
        
        let row0item = TableItem(text: "Sleep Analysis")
        measurements.append(row0item)
        
        super.init(coder: aDecoder)
    }

    
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SleepItem") as UITableViewCell
            let item = measurements[indexPath.row]
            let label = cell.viewWithTag(1040) as UILabel
            label.text = item.text
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            return cell
    }
}
