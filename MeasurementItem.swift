//
//  MeasurementItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import Foundation

class MeasurementItem: TableItem {
    
    var group: String
    var value: Double
    var date: String
    var unit: String
    var sliderLimit: Float

    required init() {
    
        self.group = String()
        self.value = Double()
        self.date = String()
        self.unit = String()
        self.sliderLimit = Float()
        
        super.init()
    }
    
    required convenience init(name: String, nameInDatabase: String, unit: String, group: String) {
        
        self.init()
        
        self.name = name
        self.nameInDatabase = nameInDatabase
        self.unit = unit
        self.group = group
    }
    
    required convenience init(name: String, nameInDatabase: String, value: Double, unit:String, date: String) {
        
        self.init()
        
        self.value = value
        self.unit = unit
        self.date = date
        self.name = name
        self.nameInDatabase = nameInDatabase
        
    }
}