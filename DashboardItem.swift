//
//  DashboardItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 16.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DashboardItem {
    
    //variables
    
    var text: String
    var itemName: String
    
    
    //initializer
    
    init(itemName: String){
        
        self.text = String()
        self.itemName = String()
        
        self.itemName = itemName
    }
}