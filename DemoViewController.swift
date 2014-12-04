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
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func synchronizeData(sender: AnyObject) {
    
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/synchronize/"
        
        var db_connection = DatabaseConnection()
        db_connection.getRequestWithoutParameterAndResponse(url)
        
        
    }
    
    @IBAction func getFitbitWaterGoal(sender: UIButton) {
        
        let url: String = "http://141.19.142.45/~johannes/focusedhealth/fitbit/water_goal/"
        
        var request = HTTPTask()
        //The parameters will be encoding as JSON data and sent.
        request.requestSerializer = JSONRequestSerializer()
        //The expected response will be JSON and be converted to an object return by NSJSONSerialization instead of a NSData.
        request.responseSerializer = JSONResponseSerializer()
        request.GET(url, parameters: nil, success: {(response: HTTPResponse) in
            if let dict = response.responseObject as? Dictionary<String,AnyObject> {
                
                var goalValue = dict["goal_value"] as String
                var startdate = dict["startdate"] as String
                var enddate = dict["enddate"] as String
                
                self.showAlertView("Water Goal\n", message: "Goal: \(goalValue)\nStartdate: \(startdate)\nEnddate: \(enddate)\n")
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
        
    }
    

    @IBAction func authenticateVitadockUser(sender: AnyObject) {
        self.doOAuthVitadock()
        
    }
    
    @IBAction func authenticateWithingsUser(sender: AnyObject) {
        self.doOAuthWithings()
        
    }

    

    @IBAction func authenticateFitbitUser(sender: AnyObject) {
        self.doOAuthFitbit();
        
    }
    
    @IBAction func logoutButton(sender : UIButton) {
        
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
    
    func showAlertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
            

            let url: NSURL = NSURL (string:"https://wbsapi.withings.net/v2/measure")!
            let action: String = "getactivity"
            
            var db_connection = DatabaseConnectionWithings2()
            
            var parameters = oauthswift_withings.client.getSignatureWithings(action, url: url)
            
            db_connection.postWithingsCredentialsToServer(parameters)
            
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    func doOAuthVitadock(){
        let oauthswift_vitadock = OAuth1Swift_Vitadock(
            consumerKey:    Vitadock["consumerKey"]!,
            consumerSecret: Vitadock["consumerSecret"]!,
            requestTokenUrl: "https://cloud.vitadock.com/auth/unauthorizedaccesses",
            authorizeUrl:    "https://cloud.vitadock.com/desiredaccessrights/request",
            accessTokenUrl:  "https://cloud.vitadock.com/auth/accesses/verify"
        )
        oauthswift_vitadock.authorizeWithCallbackURL( NSURL(string:"oauth-callback://oauth-callback/vitadock")!, success: {
            credentials, response in
            self.showAlertView("Vitadock", message: "oauth_token:\(credentials.oauth_token)\n\noauth_token_secret:\(credentials.oauth_token_secret)\n\nuser_id:\(credentials.user_id)")
            
            var parameters: Dictionary<String, AnyObject> = [
                // add vitadock params here
     //           "id"                        : "\(credentials.user_id)",
                "oauth_timestamp"           : "\(credentials.oauth_timestamp)",
                "oauth_nonce"               : "\(credentials.oauth_nonce)",
                "oauth_consumer_key"        : "\(credentials.consumer_key)",
                "oauth_token"               : "\(credentials.oauth_token)",
//                "oauth_signature"           : "\(credentials.oauth_signature)",
                "oauth_verifier"            : "\(credentials.oauth_verifier)",
                "oauth_version"             : "1.0",
                "oauth_signature_method"    : "HMAC-SHA256"
            ]
    
//            var db_connection = DatabaseConnectionVitadock()
//            
//            db_connection.postVitadockCredentialsToServer(parameters)
//            

            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
}