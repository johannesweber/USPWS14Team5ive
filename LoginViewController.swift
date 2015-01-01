//
//  LoginViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 25.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import Alamofire

import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {

    //IBOutlet
    @IBOutlet weak var txtMailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    //override functions    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.txtPassword.text = ""
        
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn == 1) {
            self.performSegueWithIdentifier("goToDashboard", sender: self)
        }
        
        self.txtMailAddress.delegate = self
        self.txtPassword.delegate = self        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtMailAddress) {
            textField.resignFirstResponder()
        } else if (textField == self.txtPassword) {
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func continueWithoutLogin(sender: UIButton) {
        
    }
    
    @IBAction func signinButton(sender : UIButton) {
        var email:String = txtMailAddress.text
        var password:String = txtPassword.text
        
        if ( email == "" || password == "" ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter E - Mail Address and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            
            let parameters: Dictionary<String, AnyObject> = [
                "email"        : "\(email)",
                "password"     : "\(password)",
            ]
            
            Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/login", parameters: parameters)
                .responseSwiftyJSON{ (request, response, json, error) in
                    println(request)
                    println(response)
                    println(json)
                    
                    var success = json["success"].intValue

                    if(success == 1) {
                        
                        println("Login SUCCESS");
                        
                        var userId = json["userId"].intValue
                        
                        prefs.setObject(email, forKey: "EMAIL")
                        prefs.setInteger(success, forKey: "ISLOGGEDIN")
                        prefs.setInteger(userId, forKey: "USERID")
                        
                        prefs.synchronize()
                        
                        self.performSegueWithIdentifier("goToDashboard", sender: self)
                        
                    } else {
                        
                        var error_msg:String
                        
                        if json["error_message"].string != nil {
                            
                            error_msg = json["error_message"].string!
                            
                        } else {
                            
                            error_msg = "Unknown Error"
                            
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
            }
            
        }
    }
}
