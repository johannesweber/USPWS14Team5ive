//
//  Category.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 12.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

/*
* this class represents a category in core data
*/

class Category: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var nameInGerman: String
    @NSManaged var nameInFrench: String

}
