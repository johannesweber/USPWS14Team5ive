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
    
    @IBAction func changePassword(sender: UIButton) {
        
        var email = self.txtMailAddress.text
        var password = self.txtNewPassword.text
        var confirmPassword = self.txtConfirmNewPassword.text
        
        //why doesn't passwords match
        if email.isValidEmail() && password != "" {
            
            if password == confirmPassword {
                
                let parameters: Dictionary<String, String> = ["email" : "\(email)", "password" : "\(password)"]
                
                Alamofire.request(.POST, "\(baseURL)/password/change/", parameters: parameters)
                    .responseSwiftyJSON { (request, response, json, error) in
                        println(request)
                        println(response)
                        println(json)
                        
                        var success = json["success"].intValue
                        var message = json["message"].string
                        
                        if success == 1 {
                            
                            showAlert( NSLocalizedString("Change Password Succesfull!", comment: "Title for Message if password was succesfully changed"),  NSLocalizedString("\(message)", comment: "Message if password succesfully changed"), self)
                        }
                }
        
            } else {
                
                showAlert( NSLocalizedString("Change Password Failed!", comment: "Title for Message if password change failed"),  NSLocalizedString("Passwords don't Match.", comment: "Message if password change failed"), self)

            }
        } else {
            
            showAlert( NSLocalizedString("Change Password Failed!", comment: "Title for Message if password change failed"),  NSLocalizedString("Please enter your E-Mail and/or Password", comment: "Message if password change failed"), self)
            
        }
    }
    
    
    
    
}
