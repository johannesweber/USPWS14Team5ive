//
//  USPWS14Team5ive.swift
//  USPWS14Team5ive
//
//  Created by Christian Dorn on 15/01/15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

/*
* this class represents a measurement in core data
*/

class Measurement: NSManagedObject {

    @NSManaged var date: String
    @NSManaged var favoriteCompany: String
    @NSManaged var groupname: String
    @NSManaged var groupnameInFrench: String
    @NSManaged var groupnameInGerman: String
    @NSManaged var isDuplicate: NSNumber
    @NSManaged var isGoalable: NSNumber
    @NSManaged var isInDashboard: NSNumber
    @NSManaged var name: String
    @NSManaged var nameInDatabase: String
    @NSManaged var nameInFrench: String
    @NSManaged var nameInGerman: String
    @NSManaged var sliderLimit: NSNumber
    @NSManaged var text: String
    @NSManaged var unit: String
    @NSManaged var value: NSNumber
    @NSManaged var dashboard: Dashboard

}
