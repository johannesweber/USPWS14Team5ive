//
//  DemoViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 21.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit


class DemoViewController: UIViewController {
    
    var userid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var useridlabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func authenticateFitbitUser(sender: AnyObject) {
        self.doOAuthFitbit();
        
    }

    @IBAction func getFitbitUserInfo(sender: AnyObject) {
        
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/user_info/"
        
        var request = HTTPTask()
        //The parameters will be encoding as JSON data and sent.
        request.requestSerializer = JSONRequestSerializer()
        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
        request.responseSerializer = JSONResponseSerializer()
        request.GET(url, parameters: nil, success: {(response: HTTPResponse) in
            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
            
//                var id = dict["user_id"] as String
//                println("ID im Response \(id)")
//                
//                self.userid = id
//
//                self.useridlabel.text = self.userid
//
//                println("ID außerhalb: \(self.userid)")
                
                var userid = dict["user_id"] as String
                var avatar = dict["avatar"] as String
                var city = dict["city"] as String
                var dateOfBirth = dict["dateOfBirth"] as String
                var companyAccountId = dict["company_account_id"] as String
                var distanceUnit = dict["distanceUnit"] as String
                var fullName = dict["fullName"] as String
                var gender = dict["gender"] as String
                var glucoseUnit = dict["glucoseUnit"] as String
                var height = dict["height"] as String
                var heightUnit = dict["heightUnit"] as String
                var locale = dict["locale"] as String
                var memberSince = dict["memberSince"] as String
                var timezone = dict["timezone"] as String
                var waterUnit = dict["waterUnit"] as String
                var weightUnit = dict["weightUnit"] as String
                
                self.showAlertView("User Info\n", message: "User ID: \(userid)\nCity: \(city)\nDate of Birth: \(dateOfBirth)\nID at Company: \(companyAccountId)\nDistance Unit: \(distanceUnit)\nFull Name: \(fullName)\nGender: \(gender)\nGlucose Unit: \(glucoseUnit)\nHeight: \(height)\nHeight Unit: \(heightUnit)\nLocale: \(locale)\nMember Since: \(memberSince)\nTimezone: \(timezone)\nWater Unit: \(waterUnit)\nWeightUnit: \(weightUnit)")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    @IBAction func authenticateWithingsUser(sender: AnyObject) {
            println("Hallo")
        self.doOAuthWithings()
       
    }
    
    
    @IBAction func authenticateMedisanaUser(sender: AnyObject) {
        
    }
    
    func doOAuthFitbit(){
        let oauthswift_fitbit = OAuth1Swift_Fitbit(
            consumerKey:    Fitbit["consumerKey"]!,
            consumerSecret: Fitbit["consumerSecret"]!,
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )
        
        oauthswift_fitbit.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/fitbit")!, success: {
            credentials, response in
            self.showAlertView("Fitbit", message: "oauth_token:\(credentials.oauth_token)\n\noauth_token_secret:\(credentials.oauth_token_secret)")
            
            let parameters: Dictionary<String, AnyObject> = [
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
                "oauth_token"               : "\(credentials.oauth_token)"
            ]
            
            var db_connection = DatabaseConnectionFitbit()
            
            db_connection.postCredentialsToServer(parameters)
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    func doOAuthWithings(){
        let oauthswift_withings = OAuth1Swift_Withings(
            consumerKey:    Withings["consumerKey"]!,
            consumerSecret: Withings["consumerSecret"]!,
            requestTokenUrl: "https://oauth.withings.com/account/request_token",
            authorizeUrl:    "https://oauth.withings.com/account/authorize",
            accessTokenUrl:  "https://oauth.withings.com/account/access_token"
        )
        oauthswift_withings.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/withings")!, success: {
            credentials, response in
            self.showAlertView("Withings", message: "oauth_token:\(credentials.oauth_token)\n\noauth_token_secret:\(credentials.oauth_token_secret)\n\nuser_id:\(credentials.user_id)")
            
            //reguläre signature in die Withings konforme Signature umwandeln
            credentials.oauth_signatureWithings = credentials.oauth_signature
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
            
            var db_connection = DatabaseConnectionWithings()
            
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
    
    func showAlertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}