//
//  FitnessViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol FitnessViewControllerDelegate: class {
    
    func fitnessViewController(controller: FitnessViewController, didSelectItem item: TableItem)
}

class FitnessViewController: UITableViewController {

    //variables
    var measurements: [TableItem]
    var labelClicked: String
    var selectedMeasurement: TableItem
    
    weak var delegate: FitnessViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder) {
        
        self.measurements = [TableItem]()
        self.selectedMeasurement = TableItem()
        self.labelClicked = String()
        
        let row0item = TableItem(name: "Steps", nameInDatabase: "steps")
        measurements.append(row0item)
        
        let row1item = TableItem(name: "Duration", nameInDatabase: "duration")
        measurements.append(row1item)
        
        let row2item = TableItem(name: "Distance", nameInDatabase: "distance")
        measurements.append(row2item)
        
        let row3item = TableItem(name: "Calories Burned", nameInDatabase: "caloriesOut")
        measurements.append(row3item)
        
        let row4item = TableItem(name: "Elevation", nameInDatabase: "elevation")
        measurements.append(row4item)
        

        
        super.init(coder: aDecoder)
    }
    
    //passing the selected object to DiagrammViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "goToDiagramFromFitness" {
            
            let destinationViewController = segue.destinationViewController as DiagramViewController
            self.delegate = destinationViewController
            
        }
    }
    
    //table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return measurements.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("FitnessItem") as UITableViewCell
            let item = measurements[indexPath.row]
            let label = cell.viewWithTag(1010) as UILabel
            label.text = item.name
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedMeasurement = self.measurements[indexPath.row]
        
        self.delegate?.fitnessViewController(self, didSelectItem: self.selectedMeasurement)
    }
}
