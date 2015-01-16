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
    @NSManaged var startdate: String
    @NSManaged var unit: String
    @NSManaged var targetValue: NSNumber
    @NSManaged var currentValue: NSNumber
    @NSManaged var text: String
    @NSManaged var measurement: String
    
}
