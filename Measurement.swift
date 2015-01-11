//
//  USPWS14Team5ive.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 10.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

class Measurement: NSManagedObject {

    @NSManaged var checked: Bool
    @NSManaged var date: String
    @NSManaged var favoriteCompany: String
    @NSManaged var groupname: String
    @NSManaged var groupnameInGerman: String
    @NSManaged var groupnameInFrench: String
    @NSManaged var name: String
    @NSManaged var nameInDatabase: String
    @NSManaged var nameInGerman: String
    @NSManaged var nameInFrench: String
    @NSManaged var sliderLimit: Int64
    @NSManaged var text: String
    @NSManaged var unit: String
    @NSManaged var value: Double
    
}
