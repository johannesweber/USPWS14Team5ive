//
//  CompanyItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 06.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import UIKit


class CompanyItem: TableItem {

    //variables
    var color: UIColor
    var measurements: [MeasurementItem]
    
    //initialzer
    required init () {
        
        self.color = UIColor()
        self.measurements = [MeasurementItem]()
        
        super.init()
    }
    
    required convenience init(name: String, nameInDatabase: String) {
        self.init()
        
        self.name = name
        self.nameInDatabase = nameInDatabase
    }
}