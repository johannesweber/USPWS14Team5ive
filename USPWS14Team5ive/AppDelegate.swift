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
            }
        
        }
        
        return true
    }
    
    func customizeAppearance() {
        let navigationBarTintColor = UIColor(red: 65/255, green: 192/255, blue: 194/255, alpha: 1)
        UINavigationBar.appearance().barTintColor = navigationBarTintColor
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
            
        let tabBarTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        UITabBar.appearance().barTintColor = tabBarTintColor
            
        let backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
            
        window?.tintColor = navigationBarTintColor
    }
    
    
}