//
//  SignupInformationViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class SignupInformationViewController: UIViewController {
    
    @IBAction func loginTapped(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
