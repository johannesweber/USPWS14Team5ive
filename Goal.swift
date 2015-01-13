//
//  USPWS14Team5ive.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 11.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import Alamofire

class Goal: NSManagedObject {

    @NSManaged var company: String
    @NSManaged var userId: NSNumber
    @NSManaged var period: String
    @NSManaged var sliderLimit: NSNumber
    @NSManaged var startdate: String
    @NSManaged var unit: String
    @NSManaged var targetValue: NSNumber
    @NSManaged var currentValue: NSNumber
    @NSManaged var text: String
    @NSManaged var measurement: String
    
    func createText() {
        
        //variables needed for request
        var url: String = "\(baseURL)/goals/select/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(self.userId)",
            "measurement"   : "\(self.measurement)",
            "period"        : "\(self.period)",
            "company"       : "\(self.company)",
            "limit"         : "1"
        ]
        
        //wrong user ID stored in Database
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(request)
                
                println(json)
                
                var currentValue = json[0]["current_value"].intValue
                var targetValue = json[0]["target_value"].intValue
                
                println(self.currentValue)
                println(self.targetValue)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.currentValue = currentValue
                    self.targetValue = targetValue
                    self.text = "\(self.measurement): \(currentValue) \(self.unit)"
                    
                }
                

        
        }
    }
}
