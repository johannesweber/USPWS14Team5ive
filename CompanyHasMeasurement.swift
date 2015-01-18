//
//  CompanyHasMeasurement.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 13.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData

/*
* this class represents a the table company_has_measurement from our database in core data
*/

class CompanyHasMeasurement: NSManagedObject {

    @NSManaged var company: String
    @NSManaged var measurement: String

}
