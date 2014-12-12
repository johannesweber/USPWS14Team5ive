//
//  AccountViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    var fitbit = Fitbit()
    
    @IBOutlet weak var txtUserMailAddress: UILabel!
    
    @IBAction func logoutTapped(sender: UIButton) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func authorizeFitbit(sender: UIButton) {

        fitbit.doOAuth()
    }
    
    @IBAction func authorizeWithings(sender: UIButton) {
    }
    
    @IBAction func authorizeMedisana(sender: AnyObject) {
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
        self.showCurrentUserMail()
    }

    func showCurrentUserMail(){
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if ((prefs.valueForKey("EMAIL")) != nil){
            var mailAddress:String = prefs.valueForKey("EMAIL") as String
            self.txtUserMailAddress.text = mailAddress
        }
        
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
            
            println("Token: \(credentials.oauth_token)")
            println("Token Secret: \(credentials.oauth_token_secret)")
            println("User ID: \(credentials.user_id)")
            
            
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
            
            println("\(credentials.oauth_token)")
            println()
            println("\(credentials.oauth_token_secret)")
            println()
            println("\(credentials.oauth_verifier)")
            
            
            var parameters: Dictionary<String, AnyObject> = [
                "oauth_token"               : "\(credentials.oauth_token)",
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
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
