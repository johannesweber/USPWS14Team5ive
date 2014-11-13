//
//  DatabaseConnection.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 13.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

let url = NSURL()
let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData

class DatabaseConnection {
    
        var dataString = String()

        var request = NSMutableURLRequest()
    
    init(url: NSURL, dataString: String){
        
        self.request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        
        let boundaryConstant = "----------V2ymHFg03esomerandomstuffhbqgZCaKO6jy";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        
        self.dataString = dataString
        self.request.HTTPMethod = "POST"
        
        NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
        
        let requestBodyData = (self.dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        self.request.HTTPBody = requestBodyData
        
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
        
        let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
        println("API Response: \(results)")
    }
}


