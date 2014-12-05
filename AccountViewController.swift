//
//  AccountViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    @IBOutlet weak var txtUserMailAddress: UILabel!
    

    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func welcomeMessage(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if ((prefs.valueForKey("EMAIL")) != nil){
            var mailAddress:String = prefs.valueForKey("EMAIL") as String
            self.txtUserMailAddress.text = mailAddress
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("goToSettings", sender: self)
        
        } else if indexPath.section == 1 && indexPath.row == 1 {
            self.performSegueWithIdentifier("goToAbout", sender: self)
        
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.welcomeMessage()
    }
    
    @IBAction func synchronizeFitbit(sender: UIButton) {
        self.doOAuthFitbit()
    }
    
    @IBAction func synchronizeWithings(sender: UIButton) {
        self.doOAuthWithings()
    }
    
    @IBAction func synchronizeMedisana(sender: AnyObject) {
        self.doOAuthMedisana()
    }
    
    func doOAuthFitbit(){
        let oauthswift_fitbit = OAuth1Swift(
            consumerKey:    Fitbit["consumerKey"]!,
            consumerSecret: Fitbit["consumerSecret"]!,
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
            
            var db_connection = DatabaseConnection()
            
            db_connection.postFitbitCredentialsToServer(parameters)
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    func doOAuthWithings(){
        let oauthswift_withings = OAuth1Swift(
            consumerKey:    Withings["consumerKey"]!,
            consumerSecret: Withings["consumerSecret"]!,
            requestTokenUrl: "https://oauth.withings.com/account/request_token",
            authorizeUrl:    "https://oauth.withings.com/account/authorize",
            accessTokenUrl:  "https://oauth.withings.com/account/access_token"
        )
        oauthswift_withings.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/withings")!, success: {
            credentials, response in
            
            var parameters: Dictionary<String, AnyObject> = [
                "userid"                : "\(credentials.user_id)",
                "oauth_token"           : "\(credentials.oauth_token)",
                "oauth_token_secret"    : "\(credentials.oauth_token_secret)"
            ]
            
            
            var db_connection = DatabaseConnection()
            
            db_connection.postWithingsCredentialsToServer(parameters)
            
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    func doOAuthMedisana(){
        let oauthswift_vitadock = OAuth1Swift_Vitadock(
            consumerKey:    Vitadock["consumerKey"]!,
            consumerSecret: Vitadock["consumerSecret"]!,
            requestTokenUrl: "https://cloud.vitadock.com/auth/unauthorizedaccesses",
            authorizeUrl:    "https://cloud.vitadock.com/desiredaccessrights/request",
            accessTokenUrl:  "https://cloud.vitadock.com/auth/accesses/verify"
        )
        oauthswift_vitadock.authorizeWithCallbackURL( NSURL(string:"oauth-callback://oauth-callback/vitadock")!, success: {
            credentials, response in
            self.showAlertView("Vitadock", message: "oauth_token:\(credentials.oauth_token)\n\noauth_token_secret:\(credentials.oauth_token_secret)\n\noauth_verifier:\(credentials.oauth_verifier)")
            
            var parameters: Dictionary<String, AnyObject> = [
                "oauth_timestamp"           : "\(credentials.oauth_timestamp)",
                "oauth_nonce"               : "\(credentials.oauth_nonce)",
                "oauth_consumer_key"        : "\(credentials.consumer_key)",
                "oauth_token"               : "\(credentials.oauth_token)",
                "oauth_verifier"            : "\(credentials.oauth_verifier)",
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
                "oauth_version"             : "1.0",
                "oauth_signature_method"    : "HMAC-SHA256"
            ]
            
            var db_connection = DatabaseConnection()
            
            db_connection.postVitadockCredentialsToServer(parameters)
            
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    func showAlertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
