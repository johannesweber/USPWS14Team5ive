//
//  DatabaseConnection.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 25.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

class DatabaseConnection {
    
    var result = NSString()
    var request = HTTPTask()
    var response = Dictionary<String,AnyObject>()
    
    init(){}
    
    func postSignupCredentialsToServer(parameter: Dictionary<String,AnyObject>){
        
        //The parameters will be encoding as JSON data and sent.
        request.requestSerializer = JSONRequestSerializer()
        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
        request.responseSerializer = JSONResponseSerializer()
        request.POST("http://141.19.142.45/~johannes/focusedhealth/signup", parameters: parameter, success: {(response: HTTPResponse) in
            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
                println("print the whole response: \(response.responseObject)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    func getRequestWithoutParameterAndResponse(url: String){
        
        self.request.GET(url, parameters: nil, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str)") //prints the HTML of the page
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    func getResponse()->Dictionary<String,AnyObject>{
        return self.response
    }
    
    //Send Fitbit OAuth Credentials
    func postFitbitCredentialsToServer(parameter: Dictionary<String,AnyObject>){
        
    let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/authorize/"
    var request = HTTPTask()
        
        request.POST(url, parameters: parameter, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let resultStr = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println("Result: \(resultStr)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
        })
    }
    
    //Send Withings OAuth Credentials
    func postWithingsCredentialsToServer(parameter: Dictionary<String,AnyObject>){
        
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/withings/authorize"
        var request = HTTPTask()
        
        request.GET(url, parameters: parameter, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let resultStr = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println("Result: \(resultStr)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
        })
    }
    
    //Send Vitadock OAuth Credentials
    func postVitadockCredentialsToServer(parameter: Dictionary<String,AnyObject>){
        
        let url: String = "http://141.19.142.45/~christian/focusedhealth/vitadock/authorize"
        var request = HTTPTask()
        
        request.GET(url, parameters: parameter, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let resultStr = NSString(data: data, encoding: NSUTF8StringEncoding)!
                
                println("Result: \(resultStr)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
        })
    } 

}