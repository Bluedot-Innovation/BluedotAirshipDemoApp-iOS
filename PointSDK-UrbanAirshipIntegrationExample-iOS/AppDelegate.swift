//
//  AppDelegate.swift
//  UrbanAirshipSDKTest
//
//  Created by Jason Xie on 11/05/2016.
//  Copyright © 2016 Jason Xie. All rights reserved.
//

import UIKit
import BDPointSDK
import AirshipKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        BDLocationManager.instance()?.locationDelegate = self
        
        UAirship.takeOff()
        UAirship.push().userPushNotificationsEnabled = true
        
        return true
    }
}
