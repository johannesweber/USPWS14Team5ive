//
//  CreateMeasurement.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 08.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Alamofire
import SwiftyJSON

func fetchMeasurementsFromUser() {
    
    var userId = prefs.integerForKey("USERID") as Int
    
    var url = "\(baseURL)/measurement/select/all"
    
    let parameters: Dictionary<String, AnyObject> = [
        
        "userId"        : "\(userId)",
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
        .responseSwiftyJSON { (request, response, json, error) in
            
            println(request)
            println(response)
            
            println("JSON: \(json)")
            
            for (var i = 0; i < json.count; i++) {
                
                var jsonObject = json[i]
                
                insertMeasurementIntoCoreData(jsonObject)
            }
    }
}

func insertMeasurementIntoCoreData(json: SwiftyJSON.JSON) {
    
    var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var context: NSManagedObjectContext = appDel.managedObjectContext!
    
    var name = json["nameInApp"].stringValue
    
    var measurement = NSEntityDescription.insertNewObjectForEntityForName("Measurement", inManagedObjectContext: context) as Measurement
    
    measurement.name = json["nameInApp"].stringValue
    measurement.nameInDatabase = json["name"].stringValue
    measurement.groupname = json["groupname"].stringValue
    measurement.groupnameInGerman = json["groupnameInGerman"].stringValue
    measurement.unit = json["unit"].stringValue
    measurement.sliderLimit = json["sliderLimit"].intValue
    measurement.favoriteCompany = json["favoriteCompany"].stringValue
    
    
    var error: NSError?
    if context.save(&error) {
        
        println("\(name) successfully inserted")
        
    } else {
        
        println("ouch: \(error)")
    }
}
