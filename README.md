## UrbanAirshipSDKTest

A sample project used to test the integration between UrbanAirship SDK and Bluedot Point SDK.

### Configuration
#### UrbanAirship
The UrbanAirship app is setup via [UrbanAirship Portal](https://go.urbanairship.com/apps/) under [company's devops account](http://secretserver.internal.bluedot.com.au/SecretView.aspx?secretid=1253).

The latest UrbanAirship SDK for iOS can be downloaded [here](https://bintray.com/urbanairship/iOS/urbanairship-sdk/8.3.3).

The integration guide can be found in the company's GitHub repo for the [integration adapter](https://github.com/Bluedot-Innovation/UrbanAirshipAdapters). This application uses [Cocoapods integration](https://docs.urbanairship.com/platform/ios/#update-the-podfile).

    Project name: BluedotUrbanAirshipIntegration
    Bundle ID: au.com.bluedot.UrbanAirshipSDKTest
    AirshipConfig.plist has been created and attached to the project.

> Notes: This app is only setup for debug builds. Will not be working for release builds.

### Project setup
1. Credentials
    
    a. Setup your apiKey, packageName and username constatns in Info.plist for keys with prefix of bluedot

    b. The project will communicate with UAT3 by default. It can be modified in UABluedotLocationServiceAdapter.m
2. Point SDK integration. Please use [Cocaopods](https://cocoapods.org/pods/BluedotPointSDK) to add PointSDK.