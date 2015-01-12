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

func insertCompaniesFromUser() {
    
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
                    
                } else {
                    
                    fatalCoreDataError(error)
                }
            }
    }

}

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
}

func insertCategories() {
    
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
                    
                } else {
                    
                    fatalCoreDataError(error)
                }
            }
    }
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

func insertFocusedHealthCompanyIntoCoreData() {
    
    var userId = prefs.integerForKey("USERID") as Int
    
    var focusedHealtCompany = CompanyItem()
    
    focusedHealtCompany.name = "Focused Health"
    focusedHealtCompany.nameInDatabase = "focused health"
    focusedHealtCompany.text = "default company for every user"
    
    insertCompanyIntoCoreData(userId, focusedHealtCompany)
}
