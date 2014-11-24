//
//  LoginViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 23.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textfieldMail: UITextField!
    
    
    @IBOutlet weak var textfieldPassword: UITextField!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func verifyMethod(sender: UIButton!) {
        
        var mail = "5ive@fh.com"
        var password = "wearegreat!"
        
        if textfieldMail.text.isEmpty {
            
            errorLabel.text = "Please enter your E - Mail Address"
            errorLabel.textColor = UIColor.redColor()
        }
        
        if textfieldPassword.text.isEmpty {
 
            errorLabel.text = "Please enter your Password"
            errorLabel.textColor = UIColor.redColor()

        }
        
        if textfieldMail.text.isEmpty && textfieldPassword.text.isEmpty {
            
            errorLabel.text = "Please enter your Credentials"
            errorLabel.textColor = UIColor.redColor()
        
        }else if textfieldMail.text.isValidEmail() &&
            textfieldMail.text == mail &&
            textfieldPassword.text == password{
                
                errorLabel.text = "Credentials were correct"
                errorLabel.textColor = UIColor.greenColor()
                textfieldPassword.resignFirstResponder()
                textfieldMail.resignFirstResponder()
            
        }else{
            
            errorLabel.text = "Credentials were not correct"
            errorLabel.textColor = UIColor.redColor()
            textfieldMail.resignFirstResponder()
            textfieldPassword.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
