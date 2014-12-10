//
//  weekday.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 07.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

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