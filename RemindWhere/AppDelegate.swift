//
//  AppDelegate.swift
//  RemindWhere
//
//  Created by Adriano Soares on 07/04/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

import UIKit
import CoreData
import Bolts
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let barColor          = UIColor(red: 44/255,  green: 62/255,  blue: 80/255,  alpha: 1) //
  let tintColor         = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1) //
  let selectedTintColor = UIColor(red: 39/255,  green: 174/255, blue: 96/255,  alpha: 1) //
  let backgroundColor   = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1) //
  let textColor         = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1) //
  let noteColors        = [
    UIColor(red: 22/255,  green: 160/255, blue: 133/255, alpha: 1), //rgb(22, 160, 133) //Green Sea
    UIColor(red: 41/255,  green: 128/255, blue: 185/255, alpha: 1), //rgb(41, 128, 185) //Belize Hole
    UIColor(red: 243/255, green: 156/255, blue: 18/255,  alpha: 1), //rgb(243, 156, 18) //Orange
    UIColor(red: 192/255, green: 57/255,  blue: 43/255,  alpha: 1)  //rgb(192, 57, 43)  //Pomegranate
  ]
  
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UITabBar.appearance().barTintColor = barColor
    UITabBar.appearance().tintColor = selectedTintColor
    
    var colorString = barColor.toString()
    
    UINavigationBar.appearance().tintColor = tintColor
    if let var navigationItem = UINavigationBar.appearance().topItem {
      navigationItem.titleView?.tintColor = tintColor
    }
    
    UINavigationBar.appearance().barTintColor = UIColor.colorWithString(colorString)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:tintColor]
    
    if (NSUserDefaults.standardUserDefaults().objectForKey("SendNotification") == nil) {
      NSUserDefaults.standardUserDefaults().setValue(false, forKey: "SendNotification")
      NSUserDefaults.standardUserDefaults().synchronize()
    }
    if (NSUserDefaults.standardUserDefaults().objectForKey("AlertDistance") == nil) {
      NSUserDefaults.standardUserDefaults().setValue(5.0, forKey: "AlertDistance")
      NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    Parse.enableLocalDatastore()
    
    
    if let keysFile = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist") {
      let keys = NSDictionary(contentsOfFile: keysFile)
      let applicationId = keys?.objectForKey("parseApplicationId") as! String;
      let clientKey = keys?.objectForKey("parseClientKey") as! String;
      
      Parse.setApplicationId (applicationId, clientKey: clientKey)
    } else {
      Parse.setApplicationId ("", clientKey: "")
    }
    
    
    
    
    // [Optional] Track statistics around application opens.
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    if let launchOptions = launchOptions {
      PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    } else {
      PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(["":""])
    }
    return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
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
    FBSDKAppEvents.activateApp()
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    var appState = application.applicationState
    if (appState == .Active) {
      var alert = UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK")
      alert.show()
    }
  }
}

