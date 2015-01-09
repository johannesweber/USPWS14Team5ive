//
//  USPWS14Team5ive.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 08.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

class Company: NSManagedObject {

    @NSManaged var checked: Bool
    @NSManaged var name: String
    @NSManaged var nameInDatabase: String
    @NSManaged var text: String

}
