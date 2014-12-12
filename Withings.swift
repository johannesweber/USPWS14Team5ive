//
//  Withings.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 12.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

import Foundation

import AlamoFire

import SwiftyJSON

class Withings {
    
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
    func doOAuth(){
        let oauthswift_withings = OAuth1Swift(
            consumerKey:    WithingsKey["consumerKey"]!,
            consumerSecret: WithingsKey["consumerSecret"]!,
            requestTokenUrl: "https://oauth.withings.com/account/request_token",
            authorizeUrl:    "https://oauth.withings.com/account/authorize",
            accessTokenUrl:  "https://oauth.withings.com/account/access_token"
        )
        oauthswift_withings.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/withings")!, success: {
            credentials, response in
            
            println("Token: \(credentials.oauth_token)")
            println("Token Secret: \(credentials.oauth_token_secret)")
            println("User ID: \(credentials.user_id)")
            
            
            var parameters: Dictionary<String, AnyObject> = [
                "userid"                : "\(credentials.user_id)",
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
        Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/withings/authorize/", parameters: parameters)
            .responseString { (request, response, string, error) in
                println(request)
                println(response)
                println(string as String!)
        }
    }
}
