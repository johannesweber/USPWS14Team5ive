//
//  DatabaseConnection.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 13.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

//let url = NSURL()
let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData


class DatabaseConnection {
    
        var queryString = String()
        var request = NSMutableURLRequest()
        var result = String()
    
    
    func post(url: String, query: Dictionary<String, AnyObject>){
        
        var request = HTTPTask()
        //The parameters will be encoding as JSON data and sent.
        request.requestSerializer = JSONRequestSerializer()
        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
        request.responseSerializer = JSONResponseSerializer()
        request.GET("http://141.19.142.45/~johannes/focusedhealth/fitbit/user_info", parameters: nil, success: {(response: HTTPResponse) in
            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
                var id = dict["user_id"] as String
                println("example of the JSON key: \(id)")
                println("print the whole response: \(response.responseObject)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    
    
    
    func postFitbitCredentialsToServer(credentials: OAuthSwiftCredential){
        
        
        var url = NSURL(string: "http://141.19.142.45/~christian/focusedhealth/fitbit/demo.php")
        
        var queryString: String = "oauth_token=\(credentials.oauth_token)&oauth_token_secret=\(credentials.oauth_token_secret)&user_id=\(credentials.user_id)&consumer_key=\(credentials.consumer_key)&oauth_nonce=\(credentials.oauth_nonce)&oauth_signature=\(credentials.oauth_signature)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\(credentials.oauth_timestamp)&oauth_version=1.0"
        //println(queryString)
       // self.post(url!, queryString: queryString)
        
        
    }

    func postWithingsCredentialsToServer(credentials: OAuthSwiftCredential){
        var newUrl: String = "http://141.19.142.45/~christian/focusedhealth/withings/demo.php"
        //var url = NSURL(string: "http://141.19.142.45/~christian/focusedhealth/withings/demo.php")
        
        var queryString: String = "oauth_token=\(credentials.oauth_token)&oauth_token_secret=\(credentials.oauth_token_secret)&user_id=\(credentials.user_id)&consumer_key=\(credentials.consumer_key)&oauth_nonce=\(credentials.oauth_nonce)&oauth_signature=\(credentials.oauth_signature)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=\(credentials.oauth_timestamp)&oauth_version=1.0"
        //println(queryString)
        
                    let parameters :Dictionary<String, AnyObject> = [
                    "action"                    : "getmeas",
                    "user_id"                   : "\(credentials.user_id)",
                    "oauth_consumer_key"        : "\(credentials.consumer_key)",
                    "oauth_nonce"               : "\(credentials.oauth_nonce)",
                    "oauth_signature"           : "\(credentials.signatureWithings)",
                    "oauth_signature_method"    : "HMAC-SHA1",
                    "oauth_timestamp"           : "\(credentials.oauth_timestamp)",
                    "oauth_token"               : "\(credentials.oauth_token)",
                    "oauth_version"             : "1.0"
                ]
        
        let query: Dictionary<String, AnyObject> = parameters
        self.post(newUrl, query: query)
        
    }

 
    
    func getResult(){
        println(self.result)
    }
    
    
}


