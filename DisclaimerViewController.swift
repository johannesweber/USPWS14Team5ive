//
//  DisclaimerViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

/*
* this controller does almost nothing. All logic is happening in the main.storyboard.
*
*/

class DisclaimerViewController: UIViewController {
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
