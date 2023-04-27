# Airship Events Example

A sample project used to test the integration between Airship SDK and Bluedot Point SDK.

## Getting started

This project depends on `BluedotPointSDK` and `Airship-iOS-SDK`. Both dependencies can be managed by Cocoapods. Please refer to the `Podfile` in the repository.


### Pre-requisite
Install git-lfs and lfs using the below commands:

```
brew install git-lfs

git lfs install
```

### Implement `BluedotPointSDK`

1. Follow official [Bluedot documentation](https://docs.bluedot.io/ios-sdk/ios-quick-start/) to integrate Bluedot iOS PointSDK into your app.

2. Update value of `bluedotProjectId` inside `ViewController` class to your projectId from Bluedot Canvas

3. Start `PointSDK`'s initialization + geoTriggering service. See `initializeSDK()` function in `ViewController` class. 

4. Implement `BDPGeoTriggeringEventDelegate` to handle check-in, check-out events:

**Objective-C**
```objc
@interface YourClass () <BDPGeoTriggeringEventDelegate>
    ...
@end

@implementation YourClass
...

- (void)didEnterZone:(nonnull GeoTriggerEvent *)enterEvent {
    // your logic on checkin
}

- (void)didExitZone:(nonnull GeoTriggerEvent *)exitEvent {
    // your logic after checkout
}

@end
```

**Swift**
```swift
extension YourClass: BDPGeoTriggeringEventDelegate {

    func didEnterZone(_ enterEvent: BDZoneEntryEvent) {
        // your logic on checkin
    }
    
    func didExitZone(_ exitEvent: BDZoneExitEvent) {
        // your logic after checkout
    }
}
```

3. Assign the delegate to your class

**Objective-C**
```objc
YourClass *instanceOfYourClass = [[YourClass alloc] init];
BDLocationManager.instance.geoTriggeringEventDelegate = instanceOfYourClass;
```

**Swift**
```swift
let instanceOfYourClass = YourClass()
BDLocationManager.instance()?.geoTriggeringEventDelegate = instanceOfYourClass
```

### Implement `Airship-iOS-SDK`

1. Follow official [Airship documentation](https://docs.airship.com/platform/mobile/setup/sdk/ios/) to integrate Airship iOS SDK into your app.
Please note that Airship has to be initialized before sending any Bluedot check-in/check-out events.

2. Update Airship configurations in Application's `didFinishLaunchingWithOptions:` method as per your Airship setup: development/production app key/secret, US/EU site, notification settings...

**Objective-C**
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
    
    UAConfig *config = [UAConfig config];
    config.developmentAppKey = @"YOUR DEV APP KEY";
    config.developmentAppSecret = @"YOUR DEV APP SECRET";
    config.productionAppKey = @"YOUR PRODUCTION APP KEY";
    config.productionAppSecret = @"YOUR PRODUCTION APP SECRET";
    config.site = UASiteUS;
    config.URLAllowListScopeOpenURL = YES;
    config.URLAllowList = @[@"*"];

    [UAirship takeOff:config launchOptions:launchOptions];
    [UAirship push].userPushNotificationsEnabled = YES;
    
    ...
}
```

**Swift**
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    ...
    
    // Create Airship config
    let config = Config()

    // Set production and development separately.
    // Alternatively you can use AirshipConfig.plist file to store all Airship configurations. More details please see https://docs.airship.com/platform/mobile/setup/sdk/ios/
    config.developmentAppKey = "YOUR DEV APP KEY"
    config.developmentAppSecret = "YOUR DEV APP SECRET"

    config.productionAppKey = "YOUR PRODUCTION APP KEY"
    config.productionAppSecret = "YOUR PRODUCTION APP SECRET"

    // Set site. Either .us or .eu
    config.site = .us

    // Allow lists. User * to allow anything
    config.urlAllowList = ["*"]

    // Call takeOff
    Airship.takeOff(config, launchOptions: launchOptions)

    Airship.push.userPushNotificationsEnabled = true
    
    ...
}

```

3. Track custom `Airship` events in your checkins/checkouts. See code examples in `AppDelegate+BDPLocationEvents.swift` class.

**Objective-C**
```objc
@interface YourClass () <BDPGeoTriggeringEventDelegate>
    ...
@end

@implementation YourClass
...

- (void)didEnterZone:(nonnull GeoTriggerEvent *)enterEvent {
    NSLog(@"Entered zone: %@", enterEvent.zone.name);
    CustomEvent *event = [[CustomEvent alloc] initWithZone:enterEvent.zone fence:enterEvent.fence];
    [event track];
}

- (void)didExitZone:(nonnull GeoTriggerEvent *)exitEvent {
    NSLog(@"Exited zone: %@", exitEvent.zone.name);
    CustomEvent *event = [[CustomEvent alloc] initWithZone:exitEvent.zone fence:exitEvent.fence dwellTime:exitEvent.duration];
    [event track];
}

@end
```

**Swift**
```swift
extension YourClass: BDPGeoTriggeringEventDelegate {

    func didEnterZone(_ enterEvent: BDZoneEntryEvent) {
        print("Entered zone: \(String(describing: enterEvent.zone().name))")
        let event = CustomEvent(zone: enterEvent.zone(), fence: enterEvent.fence)
        event.track()
    }
    
    func didExitZone(_ exitEvent: BDZoneExitEvent) {
        print("Exited zone: \(String(describing: exitEvent.zone().name))")
        let event = CustomEvent(zone: exitEvent.zone(), fence: exitEvent.fence, dwellTime: exitEvent.duration)
        event.track()
    }
}
```


## Next steps
Full documentation can be found at https://docs.bluedot.io/ios-sdk/ and https://docs.airship.com/platform/mobile/setup/sdk/ios/ respectivelly.

