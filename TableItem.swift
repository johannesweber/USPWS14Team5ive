//
//  ChecklistItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

class TableItem {
    
    var text = ""
    var checked = false
    
    var startdate = NSDate()
    var enddate = NSDate()
    
    init(){}
    
    init(text: String){
        self.text = text
    }
    
    init(text: String, checked: Bool){
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked() {
        checked = !checked
    }
}