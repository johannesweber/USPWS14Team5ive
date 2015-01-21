//
//  ChecklistItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

/**
* This class represents an Item which is used for populating table views
*/


import Foundation

class TableItem: NSObject{
    
    //variables
    var text: String
    var name: String
    var nameInDatabase: String
    var checked: Bool

    //initializer
    override required init() {
        self.text = String()
        self.name = String()
        self.checked = false
        self.nameInDatabase = String()
        
        super.init()
    }
    
    convenience required init(name: String){
        
        self.init()
        
        self.name = name
    }
    
    convenience required init(name: String, nameInDatabase: String){
        
        self.init()
        
        self.nameInDatabase = nameInDatabase
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

//makes the TableItem equatable: which means if the items has the same names there are equal
extension TableItem: Equatable {}

func == (lhs: TableItem, rhs: TableItem) -> Bool {
    
    return lhs.name == rhs.name
    
}
