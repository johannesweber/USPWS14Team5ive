//
//  Fitbit.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 06.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

import AlamoFire
import SwiftyJSON

class Fitbit {
    
    let FitbitKey =
    [
        "consumerKey": "7c39abf127964bc984aba4020845ff11",
        "consumerSecret": "18c4a92f21f1458e8ac9798567d3d38c"
    ]
    
    var responseString: NSString
    var request: HTTPTask
    var responseDict: Dictionary<String,AnyObject>
    
    init(){
    
        responseString = NSString()
        request = HTTPTask()
        responseDict = Dictionary<String,AnyObject>()
        
    }
    
    /* 
    start the fitbit - oauth process and send received Credentials to Focused Health Server
    the server will receveive these credentials and store them in the focused health database
     */
    func doOAuth(){
        let oauthswift_fitbit = OAuth1Swift(
            consumerKey:    FitbitKey["consumerKey"]!,
            consumerSecret: FitbitKey["consumerSecret"]!,
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )
        
        oauthswift_fitbit.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/fitbit")!, success: {
            credentials, response in
            
            let parameters: Dictionary<String, AnyObject> = [
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
                "oauth_token"               : "\(credentials.oauth_token)"
            ]
            
            self.postCredentialsToServer(parameters)
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    //Send Fitbit OAuth Credentials to Focused Health Server. used in doOauth()
    func postCredentialsToServer(parameters: Dictionary<String,AnyObject>){
        
        //TODO send success message from Focused Health Server to Smartphone
        Alamofire.request(.POST, "http://141.19.142.45/~johannes/focusedhealth/fitbit/authorize/", parameters: parameters, encoding: .URL)
            .responseString { (request, response, string, error) in
                println(string as String!)
        }
    }
    /*
    sends a request to focused health server to fetch all data from fitbit api and store them in the focused health database
    */
    func synchronizeData() {
        
        Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/fitbit/synchronize/")
            .responseString { (request, response, string, error) in
                println(string)
        }
    }
    
    /*
    RESTful Interfaces to retrieve data from Focused Health server
    */
    
    func getUserInfo() {
        
        Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/fitbit/user_info/")
            .responseSwiftyJSON { (request, response, json, error) in
                println(json)
                let dateOfBirth = json[0]["dateOfBirth"].string!
                println(dateOfBirth)

            }
        
        
    }
    
    func getWaterGoal() {
//        
//        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/water_goal/"
//        
//        //The parameters will be encoding as JSON data and sent.
//        request.requestSerializer = JSONRequestSerializer()
//        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
//        request.responseSerializer = JSONResponseSerializer()
//        request.GET(url, parameters: nil, success: {(response: HTTPResponse) in
//            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
//                self.responseDict = response.responseObject as Dictionary<String,AnyObject>
//                
//                //                var goalValue = dict["goal_value"] as String
//                //                var startdate = dict["startdate"] as String
//                //                var enddate = dict["enddate"] as String
//                
//            }
//            },failure: {(error: NSError, response: HTTPResponse?) in
//                println("error: \(error)")
//        })
        
    }
    
}