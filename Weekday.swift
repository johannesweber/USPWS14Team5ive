//
//  weekday.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 07.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

func getDayOfWeek(date:String)->String? {
    
    let formatter  = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let todayDate = formatter.dateFromString(date) {
        let myCalendar = NSCalendar.currentCalendar()
        let myComponents = myCalendar.components(.DayCalendarUnit, fromDate: todayDate)
        let weekday = myComponents.day
        
        switch weekday {
        case 1:
            return "Mon"
        case 2:
            return "Thu"
        case 3:
            return "Wed"
        case 4:
            return "Thu"
        case 5:
            return "Fri"
        case 6:
            return "Sat"
        case 7:
            return "Sun"
        default:
            return nil
        }
    }
    return nil
}