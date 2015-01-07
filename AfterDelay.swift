//
//  AfterDelay.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 07.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import Dispatch

func afterDelay(seconds: Double, closure: () -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}
