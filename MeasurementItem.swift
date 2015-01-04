//
//  MeasurementItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import Foundation

class MeasurementItem: TableItem {
    
    var value: Int
    var date: String
    var unit: String
    var sliderLimit: Float

    required init() {
    
        self.value = Int()
        self.date = String()
        self.unit = String()
        self.sliderLimit = Float()
        
        super.init()
    }
    
    required convenience init(name: String, nameInDatabase: String, value: Int, unit:String, date: String) {        
        self.init()
        
        self.value = value
        self.unit = unit
        self.date = date
        self.name = name
        self.nameInDatabase = nameInDatabase
        
    }
}