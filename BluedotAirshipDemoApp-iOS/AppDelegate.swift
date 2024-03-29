//
//  AppDelegate.swift
//  AirshipSDKTest
//

import UIKit
import BDPointSDK
import AirshipCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        BDLocationManager.instance()?.geoTriggeringEventDelegate = self
        BDLocationManager.instance()?.requestWhenInUseAuthorization()
        
        
        // Create Airship config
        let config = AirshipConfig()
        
        // Set production and development separately.
        // Alternatively you can use AirshipConfig.plist file to store all Airship configurations. More details please see https://docs.airship.com/platform/mobile/setup/sdk/ios/
        config.developmentAppKey = "Airship Development App Key" // Should be taken from Airship Project Settings -> Project Details -> APP KEY
        config.developmentAppSecret = "Airship Development App Secret" // Should be taken from Airship Project Settings -> Project Details -> SECRET
        
        config.productionAppKey = "YOUR PRODUCTION APP KEY"
        config.productionAppSecret = "YOUR PRODUCTION APP SECRET"
        
        // Set site. Either .us or .eu
        config.site = .us
        
        // Allow lists. User * to allow anything
        config.urlAllowList = ["*"]
        
        // Call takeOff
        Airship.takeOff(config, launchOptions: launchOptions)
        
        Airship.push.userPushNotificationsEnabled = true
        
        return true
    }
}
