//
//  Functions.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 08.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import Dispatch
import UIKit
import CoreData

func afterDelay(seconds: Double, closure: () -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}

func showAlert(title: String, message: String, delegate: UIViewController){
    var alertView:UIAlertView = UIAlertView()
    alertView.title = "\(title)"
    alertView.message = "\(message)"
    alertView.delegate = delegate
    alertView.addButtonWithTitle("OK")
    alertView.show()
}

func getDayOfWeek(date:String)->String? {
    
    let dateStyler = NSDateFormatter()
    dateStyler.dateFormat = "yyyy-MM-dd"
    
    let dateAsNSDate = dateStyler.dateFromString(date)!
    
    let weekday = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitWeekday, fromDate: dateAsNSDate).weekday
    
    switch weekday {
    case 1:
        return "Son"
    case 2:
        return "Mon"
    case 3:
        return "Tue"
    case 4:
        return "Wed"
    case 5:
        return "Thu"
    case 6:
        return "Fri"
    case 7:
        return "Sat"
    default:
        return nil
    }
}

func fetchCompanyFromCoreData() -> NSArray{
    
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext = appDel.managedObjectContext!
    
    var request = NSFetchRequest(entityName: "Company")
    request.returnsObjectsAsFaults = false
    
    //TODO add error handling
    var results: NSArray = context.executeFetchRequest(request, error: nil)!
    
    return results
}




