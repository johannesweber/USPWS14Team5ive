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
    }
}
