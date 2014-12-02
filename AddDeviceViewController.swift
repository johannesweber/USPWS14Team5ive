//
//  AddDeviceViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {

    @IBOutlet weak var devicePicker: UIPickerView!
    
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func add (sender: UIBarButtonItem) {
        
    }
}
