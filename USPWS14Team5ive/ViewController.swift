//
//  ViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 26.10.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    func doOAuthFitbit(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Fitbit["consumerKey"]!,
            consumerSecret: Fitbit["consumerSecret"]!,
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/fitbit")!, success: {
            credential, response in
            self.showAlertView("Fitbit", message: "auth_token:\(credential.oauth_token)\n\noauth_token_secret:\(credential.oauth_token_secret)")
            var parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.fitbit.com/1/foods/search.json", parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                    println(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })
            
            var parameters2 =  Dictionary<String, AnyObject>()
            parameters2 = [
                "amount" : "1000.0",
                "date" : "2014-10-29"
            ]
            oauthswift.client.post("https://api.fitbit.com/1/user/-/foods/log/water.json", parameters: parameters2,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                    println(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    func doOAuthVitadock(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Vitadock["consumerKey"]!,
            consumerSecret: Vitadock["consumerSecret"]!,
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/vitadock")!, success: {
            credential, response in
            self.showAlertView("Vitadock", message: "auth_token:\(credential.oauth_token)\n\noauth_token_secret:\(credential.oauth_token_secret)")
            var parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.fitbit.com/1/foods/search.json", parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                    println(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }

    func doOAuthWithings(){
        let oauthswift = OAuth1Swift(
            consumerKey:    Withings["consumerKey"]!,
            consumerSecret: Withings["consumerSecret"]!,
            requestTokenUrl: "https://oauth.withings.com/account/request_token",
            authorizeUrl:    "https://oauth.withings.com/account/authorize",
            accessTokenUrl:  "https://oauth.withings.com/account/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/withings")!, success: {
            credential, response in
            self.showAlertView("Withings", message: "oauth_token:\(credential.oauth_token)\n\noauth_token_secret:\(credential.oauth_token_secret)")

            var parameters =  Dictionary<String, AnyObject>()
            
            var p2 = credential.authorizationParameters["oauth_consumer_key"] as String
            var p3 = credential.authorizationParameters["oauth_nonce"] as String
            var p4 = credential.authorizationParameters["oauth_signature"] as String
            var p6 = credential.authorizationParameters["oauth_timestamp"] as String
            var p7 = credential.authorizationParameters["oauth_token"] as String
        
            var url: String = "https://wbsapi.withings.net/measure?" +
            "action=getmeas" +
            "&oauth_consumer_key=" + p2 +
            "&oauth_nonce=" + p3 +
            "&oauth_signature=" + p4 +
            "&oauth_signature_method=HMAC-SHA1" +
            "&oauth_timestamp=" + p6 +
            "&oauth_token=" + p7 +
            "&oauth_version=1.0" +
            "&userid=5064852"
            
            println(url)
            
            oauthswift.client.getFromWithings(url, parameters: parameters,
                success: {
                    data, response in
                    let jsonDict: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                    println(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })

            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    
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



