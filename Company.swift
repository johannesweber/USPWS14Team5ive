//
//  Company.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 07.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Company: NSManagedObject {

    @NSManaged var checked: Bool
    @NSManaged var color: UIColor
    @NSManaged var measurements: [MeasurementItem]
    @NSManaged var name: String
    @NSManaged var nameInDatabase: String
    @NSManaged var text: String

}
