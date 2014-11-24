//
//  OAuthViewController.swift
//  USPWS14Team5ive
//
//  Created by Christian Dorn on 24/11/14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import Foundation

class OAuthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var services = ["Fitbit", "Withings", "Vitadock"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "OAuth"
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

    //work in progress
    func doOAuthWithings(){
        let oauthswift_withings = OAuth1Swift_Withings(
            consumerKey:    Withings["consumerKey"]!,
            consumerSecret: Withings["consumerSecret"]!,
            requestTokenUrl: "https://oauth.withings.com/account/request_token",
            authorizeUrl:    "https://oauth.withings.com/account/authorize",
            accessTokenUrl:  "https://oauth.withings.com/account/access_token"
        )
        oauthswift_withings.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/withings")!, success: {
            credential, response in
            self.showAlertView("Withings", message: "oauth_token:\(credential.oauth_token)\n\noauth_token_secret:\(credential.oauth_token_secret)\n\nuser_id:\(credential.user_id)")

            //reguläre signature in die Withings konforme Signature umwandeln
            credential.signatureWithings = credential.oauth_signature
                .stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
                .stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                .stringByReplacingOccurrencesOfString("+", withString: "%2B", options: NSStringCompareOptions.LiteralSearch, range: nil)
                .stringByReplacingOccurrencesOfString("=", withString: "%3D", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //println("signature Withings: \(signatureWithings)")

         var parameters: Dictionary<String, AnyObject> = [
                "action"                    : "getmeas",
                "oauth_token"               : "\(credentials.oauth_token)",
                "oauth_consumer_key"        : "\(credentials.consumer_key)",
                "userid"                    : "\(credentials.user_id)",
                "oauth_oauth_verifier"      : "\(credentials.oauth_verifier)",
                "oauth_oauth_nonce"         : "\(credentials.oauth_nonce)",
                "oauth_signature"           : "\(credentials.oauth_signatureWithings)",
                "oauth_timestamp"           : "\(credentials.oauth_timestamp)",
                "oauth_version"             : "1.0",
                "oauth_signature_method"    : "HMAC-SHA1"
            ]

            var db_connection = DatabaseConnection()

            db_connection.postWithingsCredentialsToServer(credential)

            db_connection.getResult()

            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }