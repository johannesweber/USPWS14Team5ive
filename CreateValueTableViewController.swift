//
//  CreateValueTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 03.01.15.
//  Copyright (c) 2015 Johannes Weber. All rights reserved.
//

import UIKit

class CreateValueTableViewController: UITableViewController {


    //IBOutlet
    @IBOutlet weak var companyDetailLabel: UILabel!
    @IBOutlet weak var dateDetailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var valueSlider: UISlider!
    
    //IBAction
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
    }
    
}
