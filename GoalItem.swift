//
//  GoalItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

class GoalItem: TableItem {
    
    var unit: String
    var sliderLimit: Int
    var startdate: String
    var period: String
    var value: Int
    var company: String
    var progressValue: Int
    
    required init(){

        self.unit = String()
        self.sliderLimit = Int()
        self.startdate = String()
        self.period = String()
        self.value = Int()
        self.company = String()
        self.progressValue = Int()
        
        super.init()
    }
    
    convenience required init(name: String, nameInDatabase: String) {
        
        self.init()
        
        self.name = name
        self.nameInDatabase = nameInDatabase
        
    }
    
    convenience required init(name: String) {
        
        self.init()
        
        self.name = name
        
    }
    
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