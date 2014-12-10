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

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtMailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRepeatPassword: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        self.txtMailAddress.delegate = self
        self.txtPassword.delegate = self
        self.txtRepeatPassword.delegate = self
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
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter E-Mail Address and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if (password != confirmPassword) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else if (!email.isValidEmail()) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Your E - Mail is not correct"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            
            let parameters: Dictionary<String, String> = [
                "email"        : "\(email)",
                "password"     : "\(password)",
                "c_password"   : "\(confirmPassword)"
            ]

            Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/signup", parameters: parameters)
                .responseSwiftyJSON { (request, response, json, error) in
                    println(request)
                    println(response)
                    println(json)
                    
                    var success = json["success"].intValue
                    
                    if(success == 1) {
                        
                        println("Sign Up SUCCESS");
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Succesfull!"
                        alertView.message = "You are succesfully signed up!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:String
                        
                        if json["error_message"].string != nil {
                            error_msg = json["error_message"].string!
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
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
