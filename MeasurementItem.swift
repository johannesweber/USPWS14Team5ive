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
    var favoriteCompany: String

    required init() {
    
        self.group = String()
        self.value = Double()
        self.date = String()
        self.unit = String()
        self.sliderLimit = Float()
        self.favoriteCompany = String()
        
        super.init()
    }
    
    required convenience init(name: String, nameInDatabase: String, group: String) {
        
        self.init()
        
        self.name = name
        self.nameInDatabase = nameInDatabase
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
    
    func createTextForDashboard() {
        
        self.text = "\(self.name): \(self.value) \(self.unit)"
    }
}