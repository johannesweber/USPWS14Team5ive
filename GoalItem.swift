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
    var startdate: NSDate
    var period: String
    var value: Int
    var company: String
    
    override init(){

        self.unit = String()
        self.sliderLimit = Int()
        self.startdate = NSDate()
        self.period = String()
        self.value = Int()
        self.company = String()
        
        super.init()
    }
    
    override init(name: String) {
        
        self.unit = String()
        self.sliderLimit = Int()
        self.startdate = NSDate()
        self.period = String()
        self.value = Int()
        self.company = String()
        
        super.init(name: name)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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