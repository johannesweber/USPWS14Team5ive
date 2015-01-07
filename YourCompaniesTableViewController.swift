//
//  DevicesTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class YourCompaniesTableViewController: UITableViewController {
    
    //variables
    var companyItems = [Company]()
    var isSelected = Company()
    var userId = prefs.integerForKey("USERID") as Int    
    
    //variable for saving data into core data
    var managedObjectContext: NSManagedObjectContext!
    
    //IBOutlets
    @IBOutlet weak var authButton: UIButton!

    //IBActions
    @IBAction func authorize(){
            
        self.doOAuthCompanyItem(isSelected.name)
    }
    
    //override methods
    override func viewDidLoad() {
        self.authButton.enabled = false
        
        self.fetchCompaniesFromCoreData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.authButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToAddCompany" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            
            let addCompanyViewController = navigationController.viewControllers[0] as AddCompanyTableViewController
            
            addCompanyViewController.managedObjectContext = self.managedObjectContext
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        
        self.isSelected = self.companyItems[indexPath.row]
        self.authButton.enabled = true
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.companyItems.count
    }
    
    
    
    //places the TableItems in tableview rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyItem") as UITableViewCell
        
        let item = self.companyItems[indexPath.row]
        
        let label = cell.viewWithTag(4060) as UILabel
        label.text = item.name
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.companyItems.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

    }
    
    //methods
    
    /*
    start the medisana - oauth process and send received Credentials to Focused Health Server
    the server will store the credentials in the focused health database
    */
    func doOAuthMedisana(){
        let oauthswift_vitadock = OAuth1Swift_Vitadock(
            consumerKey:    MedisanaKey["consumerKey"]!,
            consumerSecret: MedisanaKey["consumerSecret"]!,
            requestTokenUrl: "https://cloud.vitadock.com/auth/unauthorizedaccesses",
            authorizeUrl:    "https://cloud.vitadock.com/desiredaccessrights/request",
            accessTokenUrl:  "https://cloud.vitadock.com/auth/accesses/verify"
        )
        oauthswift_vitadock.authorizeWithCallbackURL( NSURL(string:"oauth-callback://oauth-callback/vitadock")!, success: {
            credentials, response in
            
            var parameters: Dictionary<String, AnyObject> = [
                "oauth_token"               : "\(credentials.oauth_token)",
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
            ]
            
            self.postCredentialsToServer(parameters, companyName: "vitadock")
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    /*
    start the withings - oauth process and send received Credentials to Focused Health Server
    the server will receveive these credentials and store them in the focused health database
    */
    func doOAuthWithings() {
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
            
            self.postCredentialsToServer(parameters, companyName: "withings")
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    /*
    start the fitbit - oauth process and send received Credentials to Focused Health Server
    the server will receveive these credentials and store them in the focused health database
    */
    func doOAuthFitbit(){
        let oauthswift_fitbit = OAuth1Swift(
            consumerKey:    FitbitKey["consumerKey"]!,
            consumerSecret: FitbitKey["consumerSecret"]!,
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )
        
        oauthswift_fitbit.authorizeWithCallbackURL( NSURL(string: "oauth-callback://oauth-callback/fitbit")!, success: {
            credentials, response in
            
            let parameters: Dictionary<String, AnyObject> = [
                "oauth_token_secret"        : "\(credentials.oauth_token_secret)",
                "oauth_token"               : "\(credentials.oauth_token)",
                "userId"                    : "\(self.userId)"
            ]
            
            self.postCredentialsToServer(parameters, companyName: "fitbit")
            
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }


    
    //Send OAuth Credentials to Focused Health Server
    func postCredentialsToServer(parameters: Dictionary<String,AnyObject>, companyName: String){
        
        //TODO send success message from Focused Health Server to Smartphone
        Alamofire.request(.POST, "\(baseURL)/\(companyName)/authorize/", parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                var success = json["success"].intValue
                var message = json["message"].stringValue
                
                if success == 1 {
                    showAlert(NSLocalizedString("Success!", comment: "Title for Message which appears if request successfully executed"), NSLocalizedString("\(message)", comment: "Message which appears if request successfully executed"), self)
                }
        }
    }
    
    func synchronizeData(companyName: String) {
        
        let url = "\(baseURL)/\(companyName)/synchronize/"
        
        let parameters: Dictionary<String, AnyObject> = [
            "userId"    : "\(self.userId)"
        ]
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseString { (request, response, json, error) in
        }
    }

    
    func doOAuthCompanyItem(companyName: String){
        
        switch companyName {
            
        case "Withings":
            self.doOAuthWithings()
        case "Medisana":
            self.doOAuthMedisana()
        case "Fitbit":
            self.doOAuthFitbit()
        default:
            println("Company not found")
        }
    }
    
    func fetchCompaniesFromCoreData(){
        
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Company",inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
       
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        var error: NSError?
        let foundObjects = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        
        if foundObjects == nil {
            
            fatalCoreDataError(error)
            return
        }

        self.companyItems = foundObjects as [Company]
    }
}
