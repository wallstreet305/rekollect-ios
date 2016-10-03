//
//  AppDelegate.swift
//  FaceFlip
//
//  Created by Aqib on 08/11/2015.
//  Copyright © 2015 CodeArray. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Fabric
import TwitterKit
import OAuthSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let st = grabStoryboard()
        
        self.window?.rootViewController = st.instantiateInitialViewController()
        
        self.window?.makeKeyAndVisible()
        
        Fabric.with([Twitter.self])
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    func grabStoryboard() -> UIStoryboard
    {
        var screenHeight:CGFloat;
        screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let storyboard:UIStoryboard;
        
        if (screenHeight == 480)
        {
            storyboard = UIStoryboard(name: "Main-4s", bundle: nil)
        }else if (screenHeight == 568)
        {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }else
        {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        return storyboard;
    }
    
//    func application(application: UIApplication,
//        openURL url: NSURL,
//        sourceApplication: String?,
//        annotation: AnyObject?) -> Bool {
//           
//            
//            
//            if (url.host == "oauth-callback") {
//                OAuthSwift.handleOpenURL(url)
//            }
//            
//            return FBSDKApplicationDelegate.sharedInstance().application(
//                application,
//                openURL: url,
//                sourceApplication: sourceApplication,
//                annotation: annotation)
//    }

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
            FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

