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
        var config = AirshipConfig()
        
        // Set production and development separately.
        // Alternatively you can use AirshipConfig.plist file to store all Airship configurations. More details please see https://docs.airship.com/platform/mobile/setup/sdk/ios/

        // For Debug/XCode apps it should be taken from Airship Test Project Settings -> Channels -> iOS -> Project Details:
        // APP KEY and SECRET
        config.developmentAppKey = "5NRotEulT8CiLiXAN9qqZg" //"Airship Development App Key"
        config.developmentAppSecret = "m2OYw7SwRuyhZVASB6TASQ"// "Airship Development App Secret"
        
        // For TestFlight apps it should be taken from Airship Live Project Settings -> Channels -> iOS -> Project Details:
        // APP KEY and SECRET
        config.productionAppKey = "zjN45eRLQnKL63m0ebTbyw" //"YOUR PRODUCTION APP KEY"
        config.productionAppSecret = "lDl6vtOHQZKsJ0IHcewlcg" //"YOUR PRODUCTION APP SECRET"
        
        // Set site. Either .us or .eu
        config.site = .eu
        config.clearUserOnAppRestore = true
        
        // Allow lists. User * to allow anything
        config.urlAllowList = ["*"]
        
        #if DEBUG
        config.inProduction = false
        config.isAirshipDebugEnabled = true
        #else
        config.inProduction = true
        #endif

        
        // Call takeOff
        try! Airship.takeOff(config)
        
        Airship.push.userPushNotificationsEnabled = true
        Airship.push.notificationOptions = [.alert, .badge, .sound]
        Airship.push.defaultPresentationOptions = [.banner, .badge, .sound]
        
        Task {
            let status = await Airship.push.notificationStatus
            
            print("User notifications enabled: \(status.isUserNotificationsEnabled)")
            print("Notifications allowed: \(status.areNotificationsAllowed)")
            print("Privacy feature enabled: \(status.isPushPrivacyFeatureEnabled)")
            print("Push token registered: \(status.isPushTokenRegistered)")
            print("User opted in: \(status.isUserOptedIn)")
            print("Fully opted in: \(status.isOptedIn)")
            print("Display status: \(status.displayNotificationStatus)")
        }

        
        return true
    }
}
