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
import UIKit

class Fitbit {
    
    //variables
    
    var userId = prefs.integerForKey("USERID") as Int
    var response = SwiftyJSON.JSON
    var syncSuccess = Int()
    var syncMessage = String()
    
    let FitbitKey = [
        
        "consumerKey"       : "7c39abf127964bc984aba4020845ff11",
        "consumerSecret"    : "18c4a92f21f1458e8ac9798567d3d38c"
    ]
    
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
            
            var userId = prefs.integerForKey("USERID") as Int
            
            println(userId)
            
            let parameters: Dictionary<String, AnyObject> = [
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
                "oauth_token"               : "\(credentials.oauth_token)",
                "userId"                    : "\(userId)"
            ]
            
            self.postCredentialsToServer(parameters)
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    //Send Fitbit OAuth Credentials to Focused Health Server. used in doOauth()
    func postCredentialsToServer(parameters: Dictionary<String,AnyObject>){
        
        //TODO send success message from Focused Health Server to Smartphone
        Alamofire.request(.POST, "\(baseURL)/fitbit/authorize/", parameters: parameters)
            .responseString { (request, response, string, error) in
        }
    }
    
    /*
    sends a request to focused health server to fetch all data from fitbit api and store them in the focused health database
    */
    func synchronizeData() {
        
        let url = "\(baseURL)/fitbit/synchronize/"
        
        let parameters: Dictionary<String, AnyObject> = [
            "userId"    : "\(self.userId)"
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                var success = json["success"].intValue
                var message = json["message"].stringValue
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.message = "\(message)"
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                })
        }
    }
}
