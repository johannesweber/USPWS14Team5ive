//
//  ChecklistItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

class TableItem {
    
    //variables
    
    var text: String
    var name: String
    var checked: Bool
    
    
    //initializer    
    init(name: String){
        
        self.text = String()
        self.name = String()
        self.checked = Bool()
        
        self.name = name
    }
    
    //methods
    func isChecked() -> Bool{
        
        return self.checked
    }
    
    func toggleChecked(){
        
        if checked {
            
            checked = false
        } else {
            
            checked = true
        }
    }
    
}



extension TableItem: Equatable {}

func == (lhs: TableItem, rhs: TableItem) -> Bool {
    
    return lhs.name == rhs.name
    
}
