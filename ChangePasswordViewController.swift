//
//  ChangePasswordViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        self.txtConfirmNewPassword.delegate = self
        self.txtNewPassword.delegate = self
        self.txtOldPassword.delegate = self
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changePassword(sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtOldPassword) {
            textField.resignFirstResponder()
        } else if (textField == self.txtNewPassword) {
            textField.resignFirstResponder()
        } else if (textField == self.txtConfirmNewPassword) {
            textField.resignFirstResponder()
        }
        return true
    }
}
