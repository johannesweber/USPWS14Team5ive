//
//  USPWS14Team5ive.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 14.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

/*
* this class represents a company in core data
*/

class Company: NSManagedObject {

    @NSManaged var checked: Bool
    @NSManaged var name: String
    @NSManaged var nameInDatabase: String
    @NSManaged var text: String

}
