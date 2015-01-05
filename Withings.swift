//
//  Withings.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 12.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import AlamoFire
import SwiftyJSON

class Withings {
    
    var userId = prefs.integerForKey("USERID") as Int
    var response = SwiftyJSON.JSON

    let WithingsKey =
    [
        "consumerKey": "0b1de1b1e2473372f5e8e30d0f13e38f9b20c84320cf8243517e73c0c084",
        "consumerSecret": "cdb631b4102893076d6feb038fd5fe7fd28431b998881d5c001307cece802"
    ]
    
    /*
    start the fitbit - oauth process and send received Credentials to Focused Health Server
    the server will receveive these credentials and store them in the focused health database
    */
    func doOAuth() {
        let oauthswift_withings = OAuth1Swift(
            consumerKey:    WithingsKey["consumerKey"]!,
            consumerSecret: WithingsKey["consumerSecret"]!,
            requestTokenUrl: "https://oauth.withings.com/account/request_token",
            authorizeUrl:    "https://oauth.withings.com/account/authorize",
            accessTokenUrl:  "https://oauth.withings.com/account/access_token"
        )
        
        oauthswift_withings.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/withings")!, success: {
            credentials, response in
            
            var parameters: Dictionary<String, AnyObject> = [
                "user_id"               : "\(self.userId)",
                "company_account_id"    : "\(credentials.user_id)",
                "oauth_token"           : "\(credentials.oauth_token)",
                "oauth_token_secret"    : "\(credentials.oauth_token_secret)"
            ]
            
            self.postCredentialsToServer(parameters)
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    //Send Fitbit OAuth Credentials to Focused Health Server. used in doOauth()
    func postCredentialsToServer(parameters: Dictionary<String,AnyObject>){
        
        //TODO send success message from Focused Health Server to Smartphone
        Alamofire.request(.POST, "\(baseURL)/withings/authorize/", parameters: parameters)
            .responseString { (request, response, string, error) in
                println(request)
                println(response)
                println(string as String!)
        }
    }
    
    func synchronizeData() {
        
        let url = "\(baseURL)/withings/synchronize/"
        
        let parameters: Dictionary<String, AnyObject> = [
            "userId"    : "\(self.userId)"
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseString { (request, response, json, error) in
                println(request)
                println(json)
        }
    }
}
