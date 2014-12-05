//
//  DatabaseConnectionWithings.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 04.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

class DatabaseConnectionWithings {
    
    var result = NSString()
    
    init(){}
    
    func postWithingsCredentialsToServer(parameter: Dictionary<String,AnyObject>){
        
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/withings/"
        println(parameter["oauth_signature"])
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