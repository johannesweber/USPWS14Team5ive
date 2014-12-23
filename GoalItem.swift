//
//  GoalItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import UIKit

class GoalItem: TableItem {
    
    var progressView: UIProgressView
    var unit: String
    var sliderLimit: Int
    var startdate: NSDate
    var period: String
    var value: Int
    
    override init(){
        
        self.progressView = UIProgressView()
        self.unit = String()
        self.sliderLimit = Int()
        self.startdate = NSDate()
        self.period = String()
        self.value = Int()
        
        super.init()
    }
    
    override init(name: String) {
        
        self.progressView = UIProgressView()
        self.unit = String()
        self.sliderLimit = Int()
        self.startdate = NSDate()
        self.period = String()
        self.value = Int()
        
        super.init(name: name)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}