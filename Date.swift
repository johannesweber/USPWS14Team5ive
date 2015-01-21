//
//  Date.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 17.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

/**
*
* this class is used for easier creating a NSDate
*
*/

class Date {
    
    //creates a date from given int values for date moth year. returns the date.
    func from(#year:Int, month:Int, day:Int) -> NSDate {
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorian = NSCalendar(identifier:NSGregorianCalendar)
        var date = gregorian?.dateFromComponents(components)
        
        return date!
    }
    
    //creates a date from a gicen string and format. returns the date.
    func parse(dateStr:String, format:String="yyyy-MM-dd") -> NSDate {
        
        let formatter = NSDateFormatter()
        
        formatter.timeZone = NSTimeZone.defaultTimeZone()
        formatter.dateFormat = format
        
        return formatter.dateFromString(dateStr)!
    }
    

    //creates a string from a given Date. Returns the string.
    func stringFromDate(date: NSDate) -> String{
        
        let formatter = NSDateFormatter()
        
        formatter.timeStyle = .ShortStyle
        var dateString = formatter.stringFromDate(date)
        
        return dateString
    }
    
    //returns the current Date as an String. Returns the string.
    func getCurrentDateAsString() -> String{
        
        let formatter = NSDateFormatter()
        
        var date = NSDate()
        formatter.dateStyle = .MediumStyle
        formatter.dateFormat = "yyyy-MM-dd"
        var dateString = formatter.stringFromDate(date)
        
        return dateString
    }
}