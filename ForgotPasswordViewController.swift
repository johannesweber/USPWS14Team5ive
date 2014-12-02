//
//  ForgotPasswordViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmailAddress: UITextField!
    
    @IBAction func resetPassword(sender: AnyObject) {
        
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
