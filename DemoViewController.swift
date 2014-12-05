//
//  DemoViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit


class DemoViewController: UIViewController {
    
    //test: kann das response ergbenis uahc außerhalb der methode benutzt werden?
    var userid = String()
    
    @IBAction func synchronizeData(sender: AnyObject) {
    
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/synchronize/"
        
        var db_connection = DatabaseConnection()
        db_connection.getRequestWithoutParameterAndResponse(url)
        
        
    }
    
    @IBAction func getFitbitWaterGoal(sender: UIButton) {
        
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/water_goal/"
        
        var request = HTTPTask()
        //The parameters will be encoding as JSON data and sent.
        request.requestSerializer = JSONRequestSerializer()
        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
        request.responseSerializer = JSONResponseSerializer()
        request.GET(url, parameters: nil, success: {(response: HTTPResponse) in
            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
                
                var goalValue = dict["goal_value"] as String
                var startdate = dict["startdate"] as String
                var enddate = dict["enddate"] as String
                
                self.showAlertView("Water Goal\n", message: "Goal: \(goalValue)\nStartdate: \(startdate)\nEnddate: \(enddate)\n")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
        
    }
    
    @IBAction func getFitbitUserInfo(sender: AnyObject) {
        
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/user_info/"
        
        var request = HTTPTask()
        //The parameters will be encoding as JSON data and sent.
        request.requestSerializer = JSONRequestSerializer()
        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
        request.responseSerializer = JSONResponseSerializer()
        request.GET(url, parameters: nil, success: {(response: HTTPResponse) in
            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
                
                var userid = dict["user_id"] as String
                var avatar = dict["avatar"] as String
                var city = dict["city"] as String
                var dateOfBirth = dict["dateOfBirth"] as String
                var companyAccountId = dict["company_account_id"] as String
                var distanceUnit = dict["distanceUnit"] as String
                var fullName = dict["fullName"] as String
                var gender = dict["gender"] as String
                var glucoseUnit = dict["glucoseUnit"] as String
                var height = dict["height"] as String
                var heightUnit = dict["heightUnit"] as String
                var locale = dict["locale"] as String
                var memberSince = dict["memberSince"] as String
                var timezone = dict["timezone"] as String
                var waterUnit = dict["waterUnit"] as String
                var weightUnit = dict["weightUnit"] as String
                
                self.showAlertView("User Info\n", message: "User ID: \(userid)\nCity: \(city)\nDate of Birth: \(dateOfBirth)\nID at Company: \(companyAccountId)\nDistance Unit: \(distanceUnit)\nFull Name: \(fullName)\nGender: \(gender)\nGlucose Unit: \(glucoseUnit)\nHeight: \(height)\nHeight Unit: \(heightUnit)\nLocale: \(locale)\nMember Since: \(memberSince)\nTimezone: \(timezone)\nWater Unit: \(waterUnit)\nWeightUnit: \(weightUnit)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    func showAlertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}