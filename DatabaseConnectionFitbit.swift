//
//  DatabaseConnection.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 24.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

class DatabaseConnectionFitbit {
    
    var result = NSString()
    
    init(){}
    
    func postCredentialsToServer(parameter: Dictionary<String,AnyObject>){
        
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
}