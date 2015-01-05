//
//  ChangePasswordViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePasswordViewController: UIViewController {
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changePassword(sender: UIButton) {
        
        
        var email = prefs.valueForKey("EMAIL") as String
        
        let parameters: Dictionary<String, String> = ["email" : "\(email)"]
        
        Alamofire.request(.POST, "\(baseURL)/password/forgot/", parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                var success = json["success"].intValue
                var message = json["message"].string!
                
                if success == 1 {
                
                    showAlert(NSLocalizedString("E-Mail has been successfully sent!", comment: "Title for Message if email has been successfully changed"),  NSLocalizedString("\(message)", comment: "Message if if email has been successfully changed"), self)
                    
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                }
                
        }
    }
}
