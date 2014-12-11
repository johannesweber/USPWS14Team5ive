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
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetPassword(sender: UIButton) {
        
        var email = self.txtMailAddress.text
        var password = self.txtNewPassword.text
        
        if email.isValidEmail() && password != "" {
            
            if password == self.txtConfirmNewPassword.text {
                
                let parameters: Dictionary<String, String> = ["email" : "\(email)", "password" : "\(password)"]
                
                Alamofire.request(.POST, "http://141.19.142.45/~johannes/focusedhealth/password/change/", parameters: parameters)
                    .responseSwiftyJSON { (request, response, json, error) in
                        println(request)
                        println(response)
                        println(json)
                }

            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Change Password Failed!"
                alertView.message = "Passwords doesn't Match."
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
