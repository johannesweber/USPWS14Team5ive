//
//  SignupInformationViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

/*
* this controller does almost nothing. All logic is happening in the main.storyboard.
*
*/

class SignupInformationViewController: UIViewController {
    
    @IBAction func loginTapped(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
