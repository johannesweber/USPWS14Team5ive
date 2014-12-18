//
//  AppDelegate.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 26.10.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        customizeAppearance()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication:String!, annotation: AnyObject!) -> Bool {
        
        if (url.host == "oauth-callback") {
            if (url.path!.hasPrefix("/vitadock") || url.path!.hasPrefix("/fitbit")) || url.path!.hasPrefix("/withings") {
                OAuth1Swift.handleOpenURL(url)
                
            } else if url.path!.hasPrefix("/password/forgot") {
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                var resetPasswordViewController = mainStoryboard.instantiateViewControllerWithIdentifier("resetPassword") as ResetPasswordViewController
                
                //TODO how to create and display an navigation controller
                var rootViewController = self.window!.rootViewController as? UINavigationController
                
                window?.rootViewController = nil
                window?.rootViewController = resetPasswordViewController
                window?.makeKeyAndVisible()
                return true
            }
        
        }
        
        return true
    }
    
    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = FHBlueColor
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
            
        let backgroundColor = FHGreyColor
            
        window?.tintColor = FHBlueColor
    }
    
    
}