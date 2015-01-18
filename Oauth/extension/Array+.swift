
//
//  Attay+.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 19.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

/*
*this class extends the Array Class with a method for testing an array if it contains an object
*/

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}