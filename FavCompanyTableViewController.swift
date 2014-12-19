//
//  FavCompanyTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Watch TV Bitch!!! on 11.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class FavCompanyTableViewController: UITableViewController {
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    var fitnessCategory:    [TableItem]
    var vitalsCategory:     [TableItem]
    var nutritionCategory:  [TableItem]
    var sleepCategory:      [TableItem]
        
    required init(coder aDecoder: NSCoder) {
        
        //set fitness array
        self.fitnessCategory = [TableItem]()
            
        let row0fitness = TableItem(text: "Steps")
        fitnessCategory.append(row0fitness)
            
        let row1fitness = TableItem(text: "Duration")
        fitnessCategory.append(row1fitness)
            
        let row2fitness = TableItem(text: "Distance")
        fitnessCategory.append(row2fitness)
            
        let row3fitness = TableItem(text: "Calories burned")
        fitnessCategory.append(row3fitness)
        
        let row4fitness = TableItem(text: "Elevation")
        fitnessCategory.append(row4fitness)
        
        //set vitals array
        self.vitalsCategory = [TableItem]()
        
        let row0vitals = TableItem(text: "Body Weight")
        vitalsCategory.append(row0vitals)
        
        let row1vitals = TableItem(text: "Body Height")
        vitalsCategory.append(row1vitals)
        
        let row2vitals = TableItem(text: "BMI")
        vitalsCategory.append(row2vitals)
        
        let row3vitals = TableItem(text: "Body Fat")
        vitalsCategory.append(row3vitals)
        
        let row4vitals = TableItem(text: "Blood Pressure")
        vitalsCategory.append(row4vitals)
    
        let row5vitals = TableItem(text: "Heart Rate")
        vitalsCategory.append(row5vitals)
        
        let row6vitals = TableItem(text: "Glucose")
        vitalsCategory.append(row6vitals)
        
        //set nutrition array
        self.nutritionCategory = [TableItem]()
        
        let row0nutrition = TableItem(text: "Food")
        nutritionCategory.append(row0nutrition)
        
        let row1nutrition = TableItem(text: "Water")
        nutritionCategory.append(row1nutrition)
        
        let row2nutrition = TableItem(text: "Calories eaten")
        nutritionCategory.append(row2nutrition)
        
        //set sleep array
        
        self.sleepCategory = [TableItem]()
        
        let row0sleep = TableItem(text: "Sleep Analysis")
        sleepCategory.append(row0sleep)

        
        
        super.init(coder: aDecoder)
        }
    
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
        
    }
    
    
    
}
