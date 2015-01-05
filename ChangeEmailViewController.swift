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
    
    @IBOutlet weak var changeMailButton: UIButton!
    
    @IBOutlet weak var txtCurrentEmail: UITextField!
    @IBOutlet weak var txtNewEmail: UITextField!
    @IBOutlet weak var txtConfirmNewEmail: UITextField!
    
    @IBOutlet weak var currentMailLabel: UILabel!
    @IBOutlet weak var newMailLabel: UILabel!
    @IBOutlet weak var confirmNewMailLabel: UILabel!
    
    var isCheckedCurrent = false
    var isCheckedNew = false
    var isCheckedConfirm = false
    
    override func viewDidAppear(animated: Bool) {
        self.txtConfirmNewEmail.delegate = self
        self.txtNewEmail.delegate = self
        self.txtCurrentEmail.delegate = self
        self.txtCurrentEmail.becomeFirstResponder()
        
        self.changeMailButton.enabled = false
        
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
        * 4. if its a valid email
        * 5. Send Request to Webserver with new Email
        * 6. write new email in database and set active to No (PHP)
        * 7. send validation/activation email (PHP)
        * 8. show confirmation message
        */
        var currentEmail = prefs.valueForKey("EMAIL") as String
        var newEmail: String
        
        
        //set the new email and save it in a dictionary
        newEmail = txtNewEmail.text
        let sendNewEmail: Dictionary<String, AnyObject> = [
            "email" : "\(newEmail)"
        ]
        
        //send changerequest to server and change the email in the database
        Alamofire.request(.GET, "\(baseURL)/", parameters: sendNewEmail).responseSwiftyJSON{(request,response,json,error) in
        
            showAlert(NSLocalizedString("Password Succesfully Changed", comment: "Title for Message if password change was successfull"),  NSLocalizedString("Please see your Inbox for further Instructions", comment: "Message if password change was successfull"), self)
         }
        
        //set the new email in the local userdata
        prefs.setObject(newEmail, forKey: "EMAIL")
    }
    
    func setLabel(label: UILabel, message: String){
        label.text = "\(message)"
    }
    
    // checks the fields for their correctness. only if all 3 textfields are checked and correct
    // the button that sends the request to change the email is enabled
    @IBAction func checkTextFields(sender: UITextField){
        if sender.tag == 101 {
            isCheckedCurrent = setLabelsCurrentMail()
        }
        
        if sender.tag == 102 {
            isCheckedNew = setLabelsNewMail()
        }
        
        if sender.tag == 103 {
            isCheckedConfirm = setLabelsConfirmNewMail()
        }
        
        if isCheckedCurrent && isCheckedNew && isCheckedConfirm {
            self.changeMailButton.enabled = true
        }
        
    }
    
    // TODO Maybe: check if field is empty(for every setLabels method. but empty can never be the registered email)
    //This method checks if all the requirements for this textfield are met.
    //Comparing emails is not case sensitive
    func setLabelsCurrentMail() -> Bool {
        //check if the current email matches the entered information in the form
        var email = prefs.valueForKey("EMAIL") as String
        if txtCurrentEmail.text.lowercaseString == email.lowercaseString{
            currentMailLabel.text = ""
            return true
        }else{
            
            setLabel(currentMailLabel, message:  NSLocalizedString("The email does not match the registered email for this account.", comment: "Message if emails do not match"))
        }
        return false
    }
    
    //This method checks if all the requirements for this textfield are met.
    //Comparing emails is not case sensitive
    func setLabelsNewMail() -> Bool {
        //check if the entered email is valid
        if txtNewEmail.text.isValidEmail(){
            newMailLabel.text = ""
            //check if the new email and the current one are different from each other
            if txtCurrentEmail.text.lowercaseString != txtNewEmail.text.lowercaseString {
                newMailLabel.text = ""
                return true
            }else{
                
                setLabel(currentMailLabel, message:  NSLocalizedString("New email cannot be identical with the current one.", comment: "Message if emails is equal to the current one"))
            }
        }else{
            
            setLabel(currentMailLabel, message:  NSLocalizedString("The email in the field 'New Email' is not a valid email.", comment: "Message if email is not valid"))
        }
        
        return false
    }
    //This method checks if all the requirements for this textfield are met.
    //Comparing emails is not case sensitive
    func setLabelsConfirmNewMail() -> Bool {
        //check if the confirm email address matches the given email in the "New Email" textfield
        if txtConfirmNewEmail.text.lowercaseString == txtNewEmail.text.lowercaseString{
            confirmNewMailLabel.text = ""
            return true
        }else{
            
            setLabel(currentMailLabel, message:  NSLocalizedString("The fields 'New Email' and 'Confirm New Email' do not match.", comment: "Message if emails do not match"))
            
            setLabel(confirmNewMailLabel, message: "The fields 'New Email' and 'Confirm New Email' do not match.")
        }
        return false
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
