//
//  DemoViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 26.10.14.
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
    //works
    func doOAuthFitbit(){
        let oauthswift_fitbit = OAuth1Swift_Fitbit(
            consumerKey:    Fitbit["consumerKey"]!,
            consumerSecret: Fitbit["consumerSecret"]!,
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )

        oauthswift_fitbit.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/fitbit")!, success: {
            credential, response in
            self.showAlertView("Fitbit", message: "oauth_token:\(credential.oauth_token)\n\noauth_token_secret:\(credential.oauth_token_secret)")
        
            var url = NSURL(string: "http://141.19.142.45/~team5ive/focusedhealth/fitbit/demo.php")
            
            var db_connection = DatabaseConnection()
            
            db_connection.postFitbitCredentialsToServer(credential)
            
            db_connection.getResult()
        

            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    //baustelle
    func doOAuthVitadock(){
        let oauthswift_vitadock = OAuth1Swift_Vitadock(
            consumerKey:    Vitadock["consumerKey"]!,
            consumerSecret: Vitadock["consumerSecret"]!,
            requestTokenUrl: "https://vitacloud.medisanaspace.com/auth/unauthorizedaccesses",
            authorizeUrl:    "https://vitacloud.medisanaspace.com/desiredaccessrights/request",
            accessTokenUrl:  "https://vitacloud.medisanaspace.com/auth/accesses/verify"
        )
        oauthswift_vitadock.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/vitadock")!, success: {
            credential, response in
            self.showAlertView("Vitadock", message: "auth_token:\(credential.oauth_token)\n\noauth_token_secret:\(credential.oauth_token_secret)")
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
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
            
            var db_connection = DatabaseConnection()
            
            db_connection.postWithingsCredentialsToServer(credential)
            
            db_connection.getResult()
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
          

            
//            //gehört zu DatabaseConnection.swift
//            //var url = NSURL(string: "http://141.19.142.45/~johannes/focusedhealth/withings/demo.php")
            

//                let parameters :Dictionary = [
//                    "user_id"             : "\(credential.user_id)",
//                    "consumer_key"        : "\(credential.consumer_key)",
//                    "nonce"               : "\(credential.oauth_nonce)",
//                    "signature"           : "\(signatureWithings)",
//                    "signature_method"    : "HMAC-SHA1",
//                    "timestamp"           : "\(credential.oauth_timestamp)",
//                    "token"               : "\(credential.oauth_token)",
//                    "version"             : "1.0"
//                ]
//            
//
//            
//            
//            oauthswift_withings.client.getFromWithings("http://141.19.142.45/~johannes/focusedhealth/withings/demo.php", parameters: parameters,
//                success: {
//                    data, response in
//                    println(data)
//                }, failure: {(error:NSError!) -> Void in
//                    println(error)
//            })
//            
//            }, failure: {(error:NSError!) -> Void in
//                println(error.localizedDescription)
//        })

    
    func showAlertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel.text = services[indexPath.row]
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        var service: String = services[indexPath.row]
        switch service {
        case "Fitbit":
            doOAuthFitbit()
        case "Withings":
            doOAuthWithings()
        case "Vitadock":
            doOAuthVitadock()
        default:
            println("default")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    
}



