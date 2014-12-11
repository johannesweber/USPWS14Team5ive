//
//  ForgotPasswordViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import Alamofire

import SwiftyJSON


class ForgotPasswordViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var txtEmailAddress: UITextField!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.txtEmailAddress.delegate = self
        self.txtEmailAddress.becomeFirstResponder()
        
    }
    
    
    @IBAction func resetPassword(sender: AnyObject) {
        
        var email = self.txtEmailAddress.text
        
        if email.isValidEmail(){
        
            let parameters: Dictionary<String, String> = ["email" : "\(email)"]
        
            Alamofire.request(.POST, "http://141.19.142.45/~johannes/focusedhealth/password/forgot/", parameters: parameters)
                    .responseSwiftyJSON { (request, response, json, error) in
                    println(request)
                    println(response)
                    println(json)
                        
                    var success = json["success"].intValue
                    var message = json["message"].string!
                        
                        if success == 1 {
                            
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "E-Mail has been successfully sent!"
                            alertView.message = message
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            
                            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                        }
                
            }
        } else {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Resetting Password Failed!"
            alertView.message = "E-Mail Address is not valid."
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
    }
}