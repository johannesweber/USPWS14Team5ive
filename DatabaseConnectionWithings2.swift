//
//  DatabaseConnectionWithings2.swift
//  USPWS14Team5ive
//
//  Created by Christian Dorn on 26/11/14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//


class DatabaseConnectionWithings2 {
    
    var result = NSString()
    
    init(){}
    
    func postWithingsCredentialsToServer(parameter: Dictionary<String,AnyObject>){
        
        let url: String = "https://wbsapi.withings.net/measure?"
        
        var request = HTTPTask()
        request.GET(url, parameters: parameter, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let resultStr = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println("Result: \(resultStr)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
        })
    }
    
    func getRequestWithoutParameter(url: String){
        
        
    }
    
}