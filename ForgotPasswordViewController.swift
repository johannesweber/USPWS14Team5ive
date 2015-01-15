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
    
    //hide keyboard if user presses on done
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtEmailAddress) {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func resetPassword(sender: AnyObject) {
        
        var email = self.txtEmailAddress.text
        
        if email.isValidEmail(){
        
            let parameters: Dictionary<String, String> = ["email" : "\(email)"]
        
            Alamofire.request(.POST, "\(baseURL)/password/forgot/", parameters: parameters)
                    .responseSwiftyJSON { (request, response, json, error) in
                        
                    var success = json["success"].intValue
                    var message = json["message"].stringValue
                        
                        if success == 1 {
                            
                            showAlert( NSLocalizedString("E-Mail has been successfully sent!", comment: "Title for Message if email was succesfully sent"),  NSLocalizedString("\(message)", comment: "Message if sign in failed"), self)
                            
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