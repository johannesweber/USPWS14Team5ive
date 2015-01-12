//
//  USPWS14Team5ive.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 11.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

class Goal: NSManagedObject {

    @NSManaged var company: String
    @NSManaged var period: String
    @NSManaged var progressValue: NSNumber
    @NSManaged var sliderLimit: NSNumber
    @NSManaged var startdate: String
    @NSManaged var unit: String
    @NSManaged var value: NSNumber
    @NSManaged var text: String
    @NSManaged var measurement: String
    
    func convertPeriodToInt() -> Int{
        
        switch self.period as String{
            
        case "Daily":
            return 1
            
        case "Weekly":
            return 2
            
        case "Monthly":
            return 3
            
        case "Annual":
            return 4
        default:
            return -1
            
        }
    }
}
