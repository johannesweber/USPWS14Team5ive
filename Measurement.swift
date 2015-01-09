//
//  Measurement.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 08.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

class Measurement: NSManagedObject {

    @NSManaged var groupname: String
    @NSManaged var groupnameInGerman: String
    @NSManaged var favoriteCompany: String
    
    //needed in database ?
    @NSManaged var value: Double
    
    //needed in database ?
    @NSManaged var date: String
    
    @NSManaged var unit: String
    @NSManaged var sliderLimit: Int
    
    //needed in database ?
    @NSManaged var text: String
    
    @NSManaged var name: String
    @NSManaged var nameInDatabase: String

    //needed in database ?
    @NSManaged var checked: Bool

}
