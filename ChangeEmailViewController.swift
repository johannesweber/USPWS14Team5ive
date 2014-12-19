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

    @IBOutlet weak var txtCurrentEmail: UITextField!
    @IBOutlet weak var txtNewEmail: UITextField!
    @IBOutlet weak var txtConfirmNewEmail: UITextField!
    
    @IBOutlet weak var currentMailLabel: UILabel!
    
    @IBOutlet weak var newMailLabel: UILabel!
    
    @IBOutlet weak var confirmNewMailLabel: UILabel!
    
    
    override func viewDidAppear(animated: Bool) {
        self.txtConfirmNewEmail.delegate = self
        self.txtNewEmail.delegate = self
        self.txtCurrentEmail.delegate = self
        self.txtCurrentEmail.becomeFirstResponder()
        
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
        * 3. check if txtNewEmail == txtConfirmNewEmail  
        * 4.if its a valid email
        * 5. Send Request to Webserver with new Email
        * 6. write new email in database and set active to No (PHP)
        * 7. send validation/activation email (PHP)
        * 8. show confirmation message
        */
        var currentEmail = prefs.valueForKey("EMAIL") as String
        var newEmail: String
        
        //check if the current email matches the entered information in the form
        if currentEmail == txtCurrentEmail.text {
            //check if the new email and the current one are different from each other
            if txtCurrentEmail.text != txtNewEmail.text{
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
                        //Alamofire.request(.GET, "141.19.142.45/...", parameters: sendNewEmail).responseSwiftyJSON{(request,response,json,error) in
                    
                           // showMessage("Password Succesfully Changed", "An email has been sent to your new account email address. Please use the activation link given in that mail.", self)
                       // }
                        
                        //set the new email in the local userdata
                        //prefs.setObject(newEmail, forKey: "EMAIL")
                
                    }else{
                        
                        setLabel(confirmNewMailLabel, message: "The fields 'New Email' and 'Confirm New Email' do not match.")
                        //showMessage("", "The fields 'New Email' and 'Confirm New Email' do not match.", self)
                    }
                }else{
                    setLabel(newMailLabel, message: "The email in the field 'New Email' is not a valid email.")
                    //showMessage("The field new email is incorrect", "The email in the field 'New Email' is not a valid email.", self)
                }
            }else{
                setLabel(newMailLabel, message: "New email is identical with the current one. Please enter a different email adress in the 'new E-Mail' field.")
                //showMessage("New email is identical with the current one", "Please enter a new email adress to change to.", self)
            }
        }else{
                setLabel(currentMailLabel, message: "The email entered in the 'current E-mail' field does not match the registered email for this account.")
            //showMessage("The information entered in the 'Current Email' field is incorrect", "The email entered in the 'Current Email' does not match the registered email for this account.", self)
        }
    }
    
    func setLabel(label: UILabel, message: String){
        label.text = "\(message)"
    }
    
    @IBAction func removeLabels(){
        currentMailLabel.text = ""
        
        newMailLabel.text = ""
        
        confirmNewMailLabel.text = ""
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtCurrentEmail) {
            textField.resignFirstResponder()
        } else if (textField == self.txtNewEmail) {
            textField.resignFirstResponder()
        } else if (textField == self.txtConfirmNewEmail) {
            textField.resignFirstResponder()
        }
        return true
    }

}
