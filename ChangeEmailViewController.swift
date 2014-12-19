//
//  ChangeEmailViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtOldEmail: UITextField!
    @IBOutlet weak var txtNewEmail: UITextField!
    @IBOutlet weak var txtConfirmNewEmail: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        self.txtConfirmNewEmail.delegate = self
        self.txtNewEmail.delegate = self
        self.txtOldEmail.delegate = self
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changeEmail(sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtOldEmail) {
            textField.resignFirstResponder()
        } else if (textField == self.txtNewEmail) {
            textField.resignFirstResponder()
        } else if (textField == self.txtConfirmNewEmail) {
            textField.resignFirstResponder()
        }
        return true
    }
}
