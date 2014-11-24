//
//  DatabaseConnection.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 13.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

class DatabaseConnection {
    
    var result = String()

    init(){

    }
    
    func postFitbitCredentialsToServer(parameter: Dictionary<String,AnyObject>){

        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/"
        
        var request = HTTPTask()
        //we have to add the explicit type, else the wrong type is inferred. See the vluxe.io article for more info.
        request.POST(url, parameters: parameter, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                let resultStr = NSString(data: data, encoding: NSUTF8StringEncoding)!
                println(resultStr)
                
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
        })
    }

}


