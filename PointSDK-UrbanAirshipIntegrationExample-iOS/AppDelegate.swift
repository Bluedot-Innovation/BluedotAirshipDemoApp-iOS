//
//  AppDelegate.swift
//  UrbanAirshipSDKTest
//
//  Created by Jason Xie on 11/05/2016.
//  Copyright © 2016 Jason Xie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        UAirship.takeOff()
        UAirship.push().userPushNotificationsEnabled = true
        
        return true
    }
}
