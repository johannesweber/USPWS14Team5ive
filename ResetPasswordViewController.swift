//
//  ResetPasswordViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 11.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import Alamofire

import SwiftyJSON

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    
    @IBOutlet weak var txtMailAddress: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        
    }
    
    
    
    // TODO
    // Add RegEx for Password. 
    // Add Labels that show the error message instead of alert views.
    @IBAction func changePassword(sender: UIButton) {
        
        var email = self.txtMailAddress.text
        var password = self.txtNewPassword.text
        var confirmPassword = self.txtConfirmNewPassword.text
        
        println(password)
        println(confirmPassword)
        
        if email.isValidEmail() && password != "" {
            
            if password == confirmPassword {
                
                let parameters: Dictionary<String, String> = ["email" : "\(email)", "password" : "\(password)"]
                
                Alamofire.request(.POST, "http://141.19.142.45/~johannes/focusedhealth/password/change/", parameters: parameters)
                    .responseSwiftyJSON { (request, response, json, error) in
                        println(request)
                        println(response)
                        println(json)
                        
                        var success = json["success"].intValue
                        var message = json["message"].string
                        
                        if success == 1 {
                            
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "Change Password Succesfull!"
                            alertView.message = message
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                        }
                }
        
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Change Password Failed!"
                alertView.message = "Passwords don't Match."
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } else {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Change Password Failed!"
            alertView.message = "Please enter your E-Mail and/or Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
    
    
    
    
}
