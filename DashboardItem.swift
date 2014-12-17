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
    
    var value: String
    var itemName: String
    
    
    //initializer
    
    init(itemName: String){
        
        self.value = String()
        self.itemName = String()
        
        self.itemName = itemName
    }
    
    
    //methods
    
    func getValueForLabel() {
        
        //variables needed for request
        var date = Date()
        var currentDate = date.getCurrentDateAsString() as String
        var userId = prefs.integerForKey("USERID") as Int
        var url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/time_series/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "endDate"       : "\(currentDate)",
            "limit"         : "1",
            "userId"        : "\(userId)",
            "measurement"   : "\(self.itemName)"
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
        }
    }
    
    func getValue(){
        
        println(self.value)
    }

}