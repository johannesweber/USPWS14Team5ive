//
//  ForgotPasswordViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import MessageUI

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var txtEmailAddress: UITextField!
    
    
    override func viewDidAppear(animated: Bool) {
        self.txtEmailAddress.delegate = self
    }
    @IBAction func resetPassword(sender: AnyObject) {
        
        // Email Subject
        var emailTitle = "Test Email"
        // Email Content
        var messageBody = "iOS programming is so fun!";
        // To address
        var toRecipents = ["weber.johanes@gmail.com"];
        
        var mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self;
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        // Present mail view controller on screen
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.txtEmailAddress) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}