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

func insertCompaniesFromUser() -> Bool {
    
    var success = false
    
    var userId = prefs.integerForKey("USERID") as Int
    
    var url = "\(baseURL)/company/select/"
    
    let parameters: Dictionary<String, AnyObject> = [
        
        "userId"        : "\(userId)",
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
        .responseSwiftyJSON { (request, response, json, error) in
            
            for(var x = 0; x < json.count; x++) {
                
                var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                
                var company = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: context) as Company
                
                company.name = json[x]["nameInApp"].stringValue
                company.nameInDatabase = json[x]["name"].stringValue
                company.checked = false
                
                var error: NSError?
                if context.save(&error) {
                    
                    success = true
                    
                } else {
                    
                    fatalCoreDataError(error)
                }
            }
    }
    
    return success

}

func insertMeasurementsFromUser() -> Bool {
    
    var success = false
    
    var userId = prefs.integerForKey("USERID") as Int
    
    var url = "\(baseURL)/measurement/select/all"
    
    let parameters: Dictionary<String, AnyObject> = [
        
        "userId"        : "\(userId)",
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
        .responseSwiftyJSON { (request, response, json, error) in
            
            for (var i = 0; i < json.count; i++) {
                
                var jsonObject = json[i]
                
                success = insertMeasurementIntoCoreData(jsonObject)
            }
    }
    
    return success
}

func insertMeasurementIntoCoreData(json: SwiftyJSON.JSON) -> Bool {
    
    var success = false
    
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
        success = true
        
    } else {
        
        fatalCoreDataError(error)
    }
    
    return success
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

func insertCompanyIntoCoreData(userId: Int, companyToInsert: CompanyItem) -> Bool{
    
    var success = false
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext = appDel.managedObjectContext!
        
    var company = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: context) as Company
    
    company.name = companyToInsert.name
    company.nameInDatabase = companyToInsert.nameInDatabase
    company.checked = companyToInsert.checked
    company.text = companyToInsert.text
        
    var error: NSError?
    if context.save(&error) {
        
        success = true
        
    } else {
            
        fatalCoreDataError(error)
    }
    
    if companyToInsert.name == "Focused Health" {
        
        var url = "\(baseURL)/company/insert/"
        
        let parameters: Dictionary<String, AnyObject> = [
            
            "userId"        : "\(userId)",
            "company"       : "\(companyToInsert.nameInDatabase)"
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseString { (request, response, json, error) in
                
                println(request)
                println(response)
                println(json)
        }
    }
    
    return success
}

func insertCategories() -> Bool{
    
    var success = false
    
    var url = "\(baseURL)/category/select/"
    
    Alamofire.request(.GET, url)
        .responseSwiftyJSON { (request, response, json, error) in
            
            for(var x = 0; x < json.count; x++) {
                
                var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                
                var category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context) as Category
                
                category.name = json[x]["name"].stringValue
                category.nameInGerman = json[x]["nameInGerman"].stringValue
                category.nameInFrench = json[x]["nameInFrench"].stringValue
                
                var error: NSError?
                if context.save(&error) {
                    
                    success = true
                    
                } else {
                    
                    fatalCoreDataError(error)
                }
            }
    }
    
    return success
}

func fetchCategoriesFromCoreData() -> [Category]{
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
    
    let fetchRequest = NSFetchRequest()
    
    let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)
    fetchRequest.entity = entity
    
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    var error: NSError?
    let foundObjects = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if foundObjects == nil {
        
        fatalCoreDataError(error)
        return foundObjects as [Category]
    }
    
    return foundObjects as [Category]
}

func insertTableCompanyHasMeasurement() -> Bool{
    
    var success = false
    
    var url = "\(baseURL)/measurement/check"
    
    Alamofire.request(.GET, url)
        .responseSwiftyJSON { (request, response, json, error) in
            
            for(var x = 0; x < json.count; x++) {
                
                var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                var context: NSManagedObjectContext = appDel.managedObjectContext!
                
                var companyHasMeasurement = NSEntityDescription.insertNewObjectForEntityForName("CompanyHasMeasurement", inManagedObjectContext: context) as CompanyHasMeasurement
                
                companyHasMeasurement.company = json[x]["company"].stringValue
                companyHasMeasurement.measurement = json[x]["measurement"].stringValue
                
                var error: NSError?
                if context.save(&error) {

                    success = true
                    
                } else {
                    
                    fatalCoreDataError(error)
                }
            }
    }
    
    return success
}


func fetchCompanyHasMeasurement(measurement: Measurement) -> [CompanyHasMeasurement]{
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
    
    let fetchRequest = NSFetchRequest()
    
    let entity = NSEntityDescription.entityForName("CompanyHasMeasurement", inManagedObjectContext: managedObjectContext)
    fetchRequest.entity = entity
    
    let sortDescriptor = NSSortDescriptor(key: "company", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let selectCompanyPredicate = NSPredicate(format: "measurement = %@", measurement.nameInDatabase)
    
    fetchRequest.predicate = selectCompanyPredicate
    
    var error: NSError?
    let foundObjects = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
    
    if foundObjects == nil {
        
        fatalCoreDataError(error)
        return foundObjects as [CompanyHasMeasurement]
    }
    
    return foundObjects as [CompanyHasMeasurement]
}


func updateDuplicateMeasurements() -> Bool{
    
    var success = false
    
    var userId = prefs.integerForKey("USERID") as Int
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
    
    var url = "\(baseURL)/measurement/select/duplicate"
    
    let parameters: Dictionary<String, AnyObject> = [
        
        "userId"        : "\(userId)",
    ]
    
    Alamofire.request(.GET, url, parameters: parameters)
        .responseSwiftyJSON { (request, response, json, error) in
            
        for(var y = 0; y < json.count; y++) {
            
            var measurementName = json[y]["nameInApp"].stringValue
            
            var isDuplicate = NSNumber(bool: true)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                success = updateMeasurement(measurementName, "isDuplicate", isDuplicate)
            }

        }
    }
    
    return success
}

func updateMeasurement(measurementName: String, property: String, newValue: AnyObject) -> Bool{
    
    var success = false
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
    
    var batchRequest = NSBatchUpdateRequest(entityName: "Measurement")
    batchRequest.propertiesToUpdate = [ property : newValue]
    batchRequest.resultType = .UpdatedObjectsCountResultType
    var error : NSError?
    
    var selectMeasurementPredicate = NSPredicate(format: "name = %@", measurementName)
    
    batchRequest.predicate = selectMeasurementPredicate
    
    var results = managedObjectContext.executeRequest(batchRequest, error: &error) as NSBatchUpdateResult
    
    if managedObjectContext.save(&error) {
        
        println("\(measurementName) successfully updated")
        success = true
        
    } else {
        
        fatalCoreDataError(error)
    }
    
    return success
}

