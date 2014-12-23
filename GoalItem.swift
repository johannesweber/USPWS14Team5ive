//
//  GoalItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import UIKit

class GoalItem: TableItem {
    
    var progressView: UIProgressView
    
    override init(name: String) {
        
        self.progressView = UIProgressView()
        
        super.init(name: name)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
