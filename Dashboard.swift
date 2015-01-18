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
* this class represents a dashboard in core data
*/

class Dashboard: NSManagedObject {

    @NSManaged var company: String
    @NSManaged var date: String
    @NSManaged var text: String
    @NSManaged var unit: String
    @NSManaged var value: NSNumber
    @NSManaged var measurement: NSSet

}
