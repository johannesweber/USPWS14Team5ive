//
//  AlertView.swift
//  USPWS14Team5ive
//
//  Created by Christian Dorn on 19/12/14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import UIKit

func showMessage(title: String, message: String, delegate: UIViewController){
    
    var alertView:UIAlertView = UIAlertView()
    alertView.title = "\(title)"
    alertView.message = "\(message)"
    alertView.delegate = delegate
    alertView.addButtonWithTitle("OK")
    alertView.show()
}