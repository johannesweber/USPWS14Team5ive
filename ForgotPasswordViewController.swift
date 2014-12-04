//
//  ForgotPasswordViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmailAddress: UITextField!
    
    
    override func viewDidAppear(animated: Bool) {
        self.txtEmailAddress.delegate = self
    }
    @IBAction func resetPassword(sender: AnyObject) {
        
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtEmailAddress) {
            textField.resignFirstResponder()
        }
        return true
    }
}
