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

func insertMeasurementsFromUser() {
    
    var userId = prefs.integerForKey("USERID") as Int
    
    var url = "\(baseURL)/measurement/select/all"
    
    let parameters: Dictionary<String, AnyObject> = [
        
        "userId"        : "\(userId)",
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
        .responseSwiftyJSON { (request, response, json, error) in

            
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
    measurement.nameInFrench = json["nameInFrench"].stringValue
    measurement.groupname = json["groupname"].stringValue
    measurement.groupnameInGerman = json["groupnameInGerman"].stringValue
    measurement.groupnameInFrench = json["groupnameInFrench"].stringValue
    measurement.unit = json["unit"].stringValue
    measurement.sliderLimit = json["sliderLimit"].intValue
    measurement.favoriteCompany = json["favoriteCompany"].stringValue
    measurement.isInDashboard = false
    measurement.text = "(default text)"
    
    var error: NSError?
    if context.save(&error) {
        
        println("\(name) successfully inserted")
        
    } else {
        
        println("ouch: \(error)")
    }
}

func fetchCompanyFromCoreData() -> [Company]{
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
    
    let fetchRequest = NSFetchRequest()
    
    let entity = NSEntityDescription.entityForName("Company", inManagedObjectContext: managedObjectContext)
    fetchRequest.entity = entity
    
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    var error: NSError?
    let foundObjects = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    if foundObjects == nil {
        
        fatalCoreDataError(error)
        return foundObjects as [Company]
    }
    
    return foundObjects as [Company]
}

func fetchMeasurementsFromCoreData() -> [Measurement]{
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
    
    let fetchRequest = NSFetchRequest()
    
    let entity = NSEntityDescription.entityForName("Measurement", inManagedObjectContext: managedObjectContext)
    fetchRequest.entity = entity
    
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    var error: NSError?
    let foundObjects = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if foundObjects == nil {
        
        fatalCoreDataError(error)
        return foundObjects as [Measurement]
    }
    
    return foundObjects as [Measurement]

}

func insertCompanyIntoCoreData(userId: Int, companyToInsert: CompanyItem) {
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext = appDel.managedObjectContext!

    var company = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: context) as Company

    company.name = companyToInsert.name
    company.nameInDatabase = companyToInsert.nameInDatabase
    company.checked = companyToInsert.checked
    company.text = companyToInsert.text
        
    var error: NSError?
    if context.save(&error) {
        

    } else {
        
        fatalCoreDataError(error)
    }
}
