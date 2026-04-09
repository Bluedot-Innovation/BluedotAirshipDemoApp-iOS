//
//  AppDelegate.swift
//  AirshipSDKTest
//

import UIKit
import BDPointSDK
import AirshipCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

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
        config.developmentAppKey = "Airship Development App Key" //"Airship Development App Key"
        config.developmentAppSecret = "Airship Development App Secret"// "Airship Development App Secret"
        
        // For TestFlight apps it should be taken from Airship Live Project Settings -> Channels -> iOS -> Project Details:
        // APP KEY and SECRET
        config.productionAppKey = "Airship Production App Key" //"Airship Production APP KEY"
        config.productionAppSecret = "Airship Production App Secret" //"Airship Production APP SECRET"
        
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

        configurePushNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BDLocationManager.instance().pushNotifications.register(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error.localizedDescription)")
    }
        
    private func configurePushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
            
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().delegate = self
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        BDLocationManager.instance().pushNotifications.onNotificationReceived = { payload in
            print("BDPoint push received: \(payload.title)")
        }
        
        BDLocationManager.instance().pushNotifications.onNotificationClicked = { payload in
            print("BDPoint push clicked: \(payload.title)")
        }
    }
}

// MARK: Push Notifications Extension UNUserNotificationCenterDelegate
extension AppDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {

        let handled = BDLocationManager.instance().pushNotifications.handleForeground(notification)
            return handled ? [.banner, .sound, .badge] : [.banner, .sound, .badge]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
            
        BDLocationManager.instance().pushNotifications.handleResponse(response)
        completionHandler()
    }
}
