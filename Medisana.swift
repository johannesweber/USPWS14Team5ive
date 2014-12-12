//
//  Medisana.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 12.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

import Foundation

import AlamoFire

import SwiftyJSON

class Medisana {
    
    var response = SwiftyJSON.JSON
    
    let MedisanaKey =

    [
        "consumerKey": "Gkn8tlAdExqgEwWw1TinYKREjZKqPdEeUgjVBuXvv6o5C1MbimLbrAJFT3Gg0yZM",
        "consumerSecret": "XqBqVYhW4fZawgS2mcn5w462smY1Rot1h2hAi2fa7A9PSAmoyfPYkKPvsZ7g6iMh"
    ]
    
    /*
    start the medisana - oauth process and send received Credentials to Focused Health Server
    the server will store the credentials in the focused health database
    */
    func doOAuth(){
        let oauthswift_vitadock = OAuth1Swift_Vitadock(
            consumerKey:    MedisanaKey["consumerKey"]!,
            consumerSecret: MedisanaKey["consumerSecret"]!,
            requestTokenUrl: "https://cloud.vitadock.com/auth/unauthorizedaccesses",
            authorizeUrl:    "https://cloud.vitadock.com/desiredaccessrights/request",
            accessTokenUrl:  "https://cloud.vitadock.com/auth/accesses/verify"
        )
        oauthswift_vitadock.authorizeWithCallbackURL( NSURL(string:"oauth-callback://oauth-callback/vitadock")!, success: {
            credentials, response in
            
            println("\(credentials.oauth_token)")
            println()
            println("\(credentials.oauth_token_secret)")
            println()
            println("\(credentials.oauth_verifier)")
            
            
            var parameters: Dictionary<String, AnyObject> = [
                "oauth_token"               : "\(credentials.oauth_token)",
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
            ]
            
            self.postCredentialsToServer(parameters)
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    //Send Fitbit OAuth Credentials to Focused Health Server. used in doOauth()
    func postCredentialsToServer(parameters: Dictionary<String,AnyObject>){
        
        //TODO send success message from Focused Health Server to Smartphone
        Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/vitadock/authorize/", parameters: parameters)
            .responseString { (request, response, string, error) in
                println(request)
                println(response)
                println(string as String!)
        }
    }
}
