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
            
            showAlert( NSLocalizedString("Sign In Failed!", comment: "Title for Message sign in failed"),  NSLocalizedString("Please enter E - Mail Address and Password", comment: "Message if sign in failed"), self)
            
        } else {
            
            let parameters: Dictionary<String, AnyObject> = [
                "email"        : "\(email)",
                "password"     : "\(password)",
            ]
            
            Alamofire.request(.GET, "\(baseURL)/login", parameters: parameters)
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
                        

                        if self.isFirstLogin() {
                            
                            self.firstTimeConfiguration(userId)
                        }

                        
                        prefs.synchronize()
                        
                        self.performSegueWithIdentifier("goToDashboard", sender: self)
                        
                    } else {
                        
                        var error_msg:String
                        
                        if json["error_message"].string != nil {
                            
                            error_msg = json["error_message"].string!
                           
                        } else {
                            
                            error_msg = "Unknown Error"
                            
                        }
                        
                        showAlert( NSLocalizedString("Sign In Failed!", comment: "Title for Message sign in failed"),  NSLocalizedString("\(error_msg)", comment: "Message if sign in failed"), self)

                    }
            }
            
        }
    }
    
    //returns true if the user has logged in for the first time
    func isFirstLogin() ->Bool {
        
        var firstTimer = false
        
        if prefs.stringForKey("FIRSTTIMELOGIN") == nil {
            println("Du bist zum ersten mal hier")
            firstTimer = true
        }
        
        return firstTimer
    }
    
    func insertFocusedHealthCompanyIntoCoreData(userId: Int) {
        
        var focusedHealtCompany = CompanyItem()
        
        focusedHealtCompany.name = "Focused Health"
        focusedHealtCompany.nameInDatabase = "focused health"
        focusedHealtCompany.text = "default company for every user"
        
        insertCompanyIntoCoreData(userId, focusedHealtCompany)
    }
    
    //this method start the daefault configuration if the user logs in for the first time
    func firstTimeConfiguration(userId: Int) {
        
        prefs.setObject("YES", forKey: "FIRSTTIMELOGIN")
        self.insertFocusedHealthCompanyIntoCoreData(userId)
        //this method fetches the measurement from the current user from focused health database an stores them into core data
        insertMeasurementsFromUser()
    }
}
