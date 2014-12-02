//
//  ChangeEmailViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var txtOldEmail: UITextField!
    @IBOutlet weak var txtNewEmail: UITextField!
    @IBOutlet weak var txtConfirmNewEmail: UITextField!
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changePassword(sender: UIButton) {
        
    }
}
