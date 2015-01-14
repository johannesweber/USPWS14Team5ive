//
//  USPWS14Team5iveTests.swift
//  USPWS14Team5iveTests
//
//  Created by Christian Dorn on 26.10.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import XCTest

//import Alamofire-SwiftyJSON for sending requests
import Alamofire
import SwiftyJSON

//import project module
import USPWS14Team5ive

class SignUpTests: XCTestCase {
    var vc: SignupViewController = SignupViewController()
    var email = "usermail@user.de"
    
    override func setUp() {
        super.setUp()
        
        var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateViewControllerWithIdentifier("SignUpView") as SignupViewController
        vc.loadView()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        var parameters: Dictionary<String, AnyObject> = [
//            "email"     :   "\(self.email)"
//        ]
//        Alamofire.request(.GET, "https://anakin.informatik.hs-mannheim.de/uip1/~timon/focusedhealth/user/delete/", parameters: parameters)
//            .responseSwiftyJSON { (request, response, json, error) in
//        
//        }
    
        super.tearDown()
    }
    
    func testPasswordAndOrEmailFieldEmpty(){
        var errorText = "Please Enter E - Mail Adress and Password"
        vc.txtMailAddress.text = ""
        vc.txtPassword.text = ""
        vc.signupButton(vc.buttonSignUp)
        XCTAssertEqual(errorText, vc.errorLabel.text!, "Both, the password and email field are empty")
        
        vc.txtMailAddress.text = ""
        vc.txtPassword.text = "asdfasdf59"
        vc.signupButton(vc.buttonSignUp)
        XCTAssertEqual(errorText, vc.errorLabel.text!, "The email field is empty")
        
        vc.txtMailAddress.text = "asdfq@qwer.de"
        vc.txtPassword.text = ""
        vc.signupButton(vc.buttonSignUp)
        XCTAssertEqual(errorText, vc.errorLabel.text!, "The password field is empty")
    }
    
    func testPasswordsDoNotMatch(){
        var errorText = "Passwords don't Match"
        vc.txtMailAddress.text = "asdfasdf@qwe.com"
        vc.txtPassword.text = "qwwertz"
        vc.txtRepeatPassword.text = "qwertz"
        vc.signupButton(vc.buttonSignUp)
        println(vc.errorLabel.text)
        XCTAssertEqual(errorText, vc.errorLabel.text!, "passwords do not match")
    }
    
    func testInvalidPassword(){
        var errorText = "The password does not meet the requirements. It has to be 6 to 18 characters long and consist of: A-Z, a-z, 0-9, ., _, %, +, #, !, -"
        
        vc.txtMailAddress.text = "asdfasdf@qwe.com"
        vc.txtPassword.text = "iampassword?"
        vc.txtRepeatPassword.text = "iampassword?"
        
        vc.signupButton(vc.buttonSignUp)
        
        XCTAssertEqual(errorText, vc.errorLabel.text!, "Password contains invalid character '?'")
    }
    
    func testInvalidEmail(){
        var errorText = "Your E - Mail is not valid. Please enter a valid E - Mail adress."
        
        vc.txtPassword.text = "asdfasdf"
        vc.txtRepeatPassword.text = "asdfasdf"
        vc.txtMailAddress.text = "asdfasdf.df"
        
        vc.signupButton(vc.buttonSignUp)
        
        XCTAssertEqual(errorText, vc.errorLabel.text!, "\(vc.txtMailAddress.text) is not a valid Email. \(errorText) should be displayed.")
        
    }
    
    func testSuccessfulSignup(){
        
//        var parameters: Dictionary<String, AnyObject> = [
//            "email"         :       "\(self.email)",
//            "password"      :       "asdfasdf",
//            "c_password"    :       "asdfasdf"
//        ]
//        
//        let expectation = expectationWithDescription("User will receive succes = 1, which means he is authenticated")
//        
//        Alamofire.request(.GET, "\(baseURL)/signup", parameters: parameters)
//            .responseSwiftyJSON { (request, response, json, error) in
//                
//                var success = json["success"].intValue
//                XCTAssertTrue(success == 1, "We make a request with valid data, so the variable success should be 1")
//                expectation.fulfill()
//                
//        }
//        waitForExpectationsWithTimeout(10) { (error) in
//            XCTAssertNil(error, "\(error)")
//        }        
    }
    
}
