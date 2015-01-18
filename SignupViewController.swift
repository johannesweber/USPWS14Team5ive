//
//  SignupViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 25.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import Alamofire

import SwiftyJSON

/*
*
* This controller is fpor the sign up screen. The user has to fill in is email and password. Further he/she has to confirm his password.
* if the password is the same as the password confirmed a new user will be created in our database. Now the user has to confirm his/her registration
* with clicking the link in the sent email.
*
*/

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtMailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRepeatPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        self.txtMailAddress.delegate = self
        self.txtPassword.delegate = self
        self.txtRepeatPassword.delegate = self
        self.txtMailAddress.becomeFirstResponder()
    }
    
    @IBAction func goToLoginTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func signupButton(sender : UIButton) {
        
        var email:String = txtMailAddress.text
        var password:String = txtPassword.text as String
        var confirmPassword:String = txtRepeatPassword.text as String
        
        if ( email == "") || (password == "") {
            
            showAlert( NSLocalizedString("Sign Up Failed!", comment: "Title for Message sign up failed"),  NSLocalizedString("Please Enter E - Mail Adress and Password", comment: "Message if sign up failed"), self)
            
            errorLabel.text = NSLocalizedString("Please Enter E - Mail Adress and Password", comment: "Message if sign up failed")
            
        } else if (password != confirmPassword) {
            
            showAlert( NSLocalizedString("Sign Up Failed!", comment: "Title for Message sign up failed"),  NSLocalizedString("Passwords don't Match", comment: "Message if sign up failed"), self)
            
            errorLabel.text = NSLocalizedString("Passwords don't Match", comment: "Message if sign up failed")
            
        } else if (!email.isValidEmail()) {
            
            showAlert( NSLocalizedString("Sign Up Failed!", comment: "Title for Message sign up failed"),  NSLocalizedString("Your E - Mail is not valid", comment: "Message if sign up failed"), self)
            
            errorLabel.text = NSLocalizedString("Your E - Mail is not valid. Please enter a valid E - Mail adress.", comment: "Message if sign up failed")
            
        } else if (!password.isValidPassword()){
            
            showAlert("Sign Up Failed!", "The password does not meet the requirements. Please enter another password.", self)
            
            errorLabel.text = NSLocalizedString("The password does not meet the requirements. It has to be 6 to 18 characters long and consist of: A-Z, a-z, 0-9, ., _, %, +, #, !, -", comment: "Message if sign up failed")
            
        } else {
            
            let parameters: Dictionary<String, String> = [
                "email"        : "\(email)",
                "password"     : "\(password)",
                "c_password"   : "\(confirmPassword)"
            ]

            Alamofire.request(.GET, "\(baseURL)/signup", parameters: parameters)
                .responseSwiftyJSON { (request, response, json, error) in
                    
                    var success = json["success"].intValue
                    
                    if(success == 1) {
                        
                        println("Sign Up SUCCESS");
                        
                        var message = json["error_message"].string!
                        
                        showAlert( NSLocalizedString("Sign Up Succesfull!", comment: "Title for Message sign up successfull"),  NSLocalizedString("\(message)", comment: "Message if sign up was successfull"), self)
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        
                        var error_msg:String
                        
                        if json["error_message"].string != nil {
                            
                            error_msg = json["error_message"].string!
                            
                        } else {
                            
                            error_msg = "Unknown Error"
                        }
                        
                        showAlert( NSLocalizedString("Sign Up Failed!", comment: "Title for Message sign up failed"),  NSLocalizedString("\(error_msg)", comment: "Message if sign up failed"), self)
                        
                    }
            }
        
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.txtMailAddress) {
            
            textField.resignFirstResponder()
            
        } else if (textField == self.txtPassword) {
            
            textField.resignFirstResponder()
            
        } else if (textField == self.txtRepeatPassword) {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
}
