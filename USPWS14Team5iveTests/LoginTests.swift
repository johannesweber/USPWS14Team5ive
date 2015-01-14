//
//  USPWS14Team5iveTests.swift
//  USPWS14Team5iveTests
//
//  Created by Johannes Weber on 26.10.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import UIKit
import XCTest

//import Frameworks
import Alamofire
import SwiftyJSON

//import project module
import USPWS14Team5ive

class LoginTests: XCTestCase {
    var vc: LoginViewController = LoginViewController()

    override func setUp() {
        super.setUp()

        var storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        vc = storyboard.instantiateViewControllerWithIdentifier("LoginView") as LoginViewController
        vc.loadView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRequestValidUser(){
        
        var success = Int()
        let expectation = expectationWithDescription("User will receive succes = 1, which means he is authenticated")
        
        let parameters: Dictionary<String, AnyObject> = [
            "email"        : "chridorn93@gmail.com",
            "password"     : "christian"
        ]

        Alamofire.request(.GET, "\(baseURL)/login", parameters: parameters)
            .responseSwiftyJSON{ (request, response, json, error) in
                
                
                    success = json["success"].intValue
                    XCTAssertTrue(success == 1, "Account does exist.")
                
                    expectation.fulfill()
            
        }
        waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "\(error)")
        }
        
    }
    
    func testRequestInvalidPasswordAndEmail() {
        

        
        let parameters: Dictionary<String, AnyObject> = [
            "email"        : "chrid3@gmal.om",
            "password"     : "chrtian",
        ]
        
        let expectation = expectationWithDescription("User will receive succes = 1, which means he is authenticated")
        
        Alamofire.request(.GET, "\(baseURL)/login", parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                XCTAssertNotNil(request, "request should not be nil")
                XCTAssertNotNil(json["error_message"].string?, "error message should not be nil")
                XCTAssertNil(error?, "We send the error message in the json, so this should be nil")
                XCTAssertEqual(json["success"].intValue, 0, "We should get an error message and success should be 0")
                
                expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
}
