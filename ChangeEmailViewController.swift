//
//  ChangeEmailViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangeEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtOldEmail: UITextField!
    @IBOutlet weak var txtNewEmail: UITextField!
    @IBOutlet weak var txtConfirmNewEmail: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        self.txtConfirmNewEmail.delegate = self
        self.txtNewEmail.delegate = self
        self.txtOldEmail.delegate = self
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //If the "Change Email" Button is pressed, this function validates the 
    //entered Information and sends a request to the server, to change
    //the users email address
    @IBAction func changeEmail(sender: UIButton) {
        /*
        * 1. check validity of old email
        * 2. check if old email is different from new Email
        * 3. check if txtNewEmail == txtConfirmNewEmail and if its a valid email
        * 4. Send Request to Webserver with new Email
        * 5. write new email in database and set active to No (PHP)
        * 6. send validation/activation email (PHP)
        * 7. show confirmation message
        */
        var oldEmail = prefs.valueForKey("EMAIL") as String
        var newEmail: String
        
        //check if the current email matches the entered information in the form
        if oldEmail == txtOldEmail.text {
            //check if the new email and the current one are different from each other
            if txtOldEmail.text != txtNewEmail.text{
                //check if the entered email is valid
                if txtNewEmail.text.isValidEmail() {
                    //check if the confirm email address matches the given email in the
                    //"New Email" textfield
                    if txtNewEmail.text == txtConfirmNewEmail.text {
                        
                        //set the new email and save it in a dictionary
                        newEmail = txtNewEmail.text
                        let sendNewEmail: Dictionary<String, AnyObject> = [
                            "email" : "\(newEmail)"
                        ]
                
                        //send changerequest to server and change the email in the database
                        Alamofire.request(.GET, "141.19.142.45/...", parameters: sendNewEmail).responseSwiftyJSON{(request,response,json,error) in
                    
                            self.showMessage("Password Succesfully Changed", message:"An email has been sent to your new account email address. Please use the activation link given in that mail.")
                        }
                        
                        //set the new email in the local userdata
                        //prefs.setObject(newEmail, forKey: "EMAIL")
                
                    }else{
                        showMessage("", message: "New Email and Confirm New Email do not match.")
                    }
                }else{
                    showMessage("", message: "New Email is not valid.")
                }
            }else{
                showMessage("New email is identical with the current one", message: "Please enter a new email adress to change to.")
            }
        }else{
            showMessage("", message: "The old Email and registered Email do not match.")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtOldEmail) {
            textField.resignFirstResponder()
        } else if (textField == self.txtNewEmail) {
            textField.resignFirstResponder()
        } else if (textField == self.txtConfirmNewEmail) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func showMessage(title: String, message: String){
        
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "\(title)"
        //text anpassen
        alertView.message = "\(message)"
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
        
    }
}
