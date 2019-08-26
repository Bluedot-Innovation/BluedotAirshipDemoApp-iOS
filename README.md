# Airship Events Example

A sample project used to test the integration between Airship SDK and Bluedot Point SDK.

## Getting started

This project depends on `BluedotPointSDK` and `Airship-iOS-SDK`. Both dependencies can be managed by Cocoapods. Please refer to the `Podfile` in the repository.

### Implement `BluedotPointSDK`
    
1. import `BDPointSDK` to your class:

**Objective-C**
```objc
@import BDPointSDK;
```

**Swift**
```swift
import BDPointSDK
```

2. Implement Bluedot location delegate:

**Objective-C**
```objc
@interface YourClass () <BDPLocationDelegate>
    ...
@end

@implementation YourClass
...

- (void)didCheckIntoFence:(BDFenceInfo *)fence
                   inZone:(BDZoneInfo *)zoneInfo
               atLocation:(BDLocationInfo *)location
             willCheckOut:(BOOL)willCheckOut
           withCustomData:(NSDictionary *)customData {
    // your logic on checkin
}

- (void)didCheckOutFromFence: (BDFenceInfo *)fence
                      inZone: (BDZoneInfo *)zoneInfo
                      onDate: (NSDate *)date
                withDuration: (NSUInteger)duration
              withCustomData: (NSDictionary *)customData {
    // your logic after checkout
}

// Beacons checkin/checkout. This is optional, unless beacons are used
- (void)didCheckIntoBeacon: (BDBeaconInfo *)beacon
                    inZone: (BDZoneInfo *)zoneInfo
                atLocation: (BDLocationInfo *)locationInfo
             withProximity: (CLProximity)proximity
              willCheckOut: (BOOL)willCheckOut
            withCustomData: (NSDictionary *)customData {
    / your logic on checkin
}

- (void)didCheckOutFromBeacon: (BDBeaconInfo *)beacon
                   inZone: (BDZoneInfo *)zoneInfo
            withProximity: (CLProximity)proximity
                   onDate: (NSDate *)date
             withDuration: (NSUInteger)duration
           withCustomData: (NSDictionary *)customData {
    // your logic after checkout
}
@end
```

**Swift**
```swift
class YourClass: BDPLocationDelegate {
    ...

    func didCheck(intoFence fence: BDFenceInfo!, 
                  inZone zoneInfo: BDZoneInfo!, 
                  atLocation location: BDLocationInfo!, 
                  willCheckOut: Bool, 
                  withCustomData customData: [AnyHashable : Any]!) {
        // your logic on checkin
    }

    func didCheckOut(fromFence fence: BDFenceInfo!, 
                     inZone zoneInfo: BDZoneInfo!, 
                     on date: Date!, 
                     withDuration checkedInDuration: UInt, 
                     withCustomData customData: [AnyHashable : Any]!) {
        // your logic after checkout
    }

    // Beacons checkin/checkout. This is optional, unless beacons are used
    func didCheck(intoBeacon beacon: BDBeaconInfo!, 
                  inZone zoneInfo: BDZoneInfo!, 
                  atLocation locationInfo: BDLocationInfo!, 
                  with proximity: CLProximity, 
                  willCheckOut: Bool, 
                  withCustomData customData: [AnyHashable : Any]!) {
        // your logic on checkin
    }
    
    func didCheckOut(fromBeacon beacon: BDBeaconInfo!, 
                     inZone zoneInfo: BDZoneInfo!, 
                     with proximity: CLProximity, 
                     on date: Date!, 
                     withDuration checkedInDuration: UInt, 
                     withCustomData customData: [AnyHashable : Any]!) {
        // your logic after checkout
    }
}
```

3. Assign location delegate with your implementation

**Objective-C**
```objc
YourClass *instanceOfYourClass = [[YourClass alloc] init];
BDLocationManager.instance.locationDelegate = instanceOfYourClass;
```

**Swift**
```swift
let instanceOfYourClass = YourClass()
BDLocationManager.instance()?.locationDelegate = instanceOfYourClass
```

4. Authenticate with the Bluedot services

**Objective-C**
```objc
[[BDLocationManager instance] authenticateWithApiKey: @"Bluedot API key" requestAuthorization: authorizedAlways];
```

**Swift**
```swift
BDLocationManager.instance()?.authenticate(withApiKey: "Bluedot API key", requestAuthorization: .authorizedAlways)
```

### Implement `Airship-iOS-SDK`

1. Import `Airship-iOS-SDK` to your class

**Objective-C**
```objc
@import AirshipKit;
```

**Swift**
```swift
import AirshipKit
```

2. Add `ArshipConfig.plist` to your project. Replace Airship `app keys` and `app secrets` with your keys.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>detectProvisioningMode</key>
	<true/>
	<key>developmentAppKey</key>
	<string>Airship development app key</string>
	<key>developmentAppSecret</key>
	<string>Airship development app secret</string>
	<key>productionAppKey</key>
	<string>Airship production app key</string>
	<key>productionAppSecret</key>
	<string>Airship production app secret</string>
</dict>
</plist>
```

3. Start `Airship`

**Objective-C**
```objc
[UAirship takeOff];
```

**Swift**
```swift
UAirship.takeOff()
```

4. Track `Airship` events in your checkins/checkouts

**Objective-C**
```objc
- (void)didCheckIntoFence:(BDFenceInfo *)fence
                   inZone:(BDZoneInfo *)zoneInfo
               atLocation:(BDLocationInfo *)location
             willCheckOut:(BOOL)willCheckOut
           withCustomData:(NSDictionary *)customData
{
    UACustomEvent *customEvent = [UACustomEvent eventWithName:@"bluedot_place_entered"];
    customEvent.interactionType = @"location";
    customEvent.interactionID = zoneInfo.ID;
    
    // Set custom event properties
    [customEvent setStringProperty:zoneInfo.name forKey:@"bluedot_zone_name"];
    for (NSString *key in customData.allKeys) {
        [customEvent setStringProperty:customData[key] forKey:key];
    }
    
    // Record the event in analytics
    [customEvent track];
}

- (void)didCheckOutFromFence: (BDFenceInfo *)fence
                      inZone: (BDZoneInfo *)zoneInfo
                      onDate: (NSDate *)date
                withDuration: (NSUInteger)duration
              withCustomData: (NSDictionary *)customData
{
    UACustomEvent *customEvent = [UACustomEvent eventWithName:@"bluedot_place_exited"];
    customEvent.interactionType = @"location";
    customEvent.interactionID = zoneInfo.ID;
    
    // Set custom event properties
    [customEvent setStringProperty:zoneInfo.name forKey:@"bluedot_zone_name"];
    for (NSString *key in customData.allKeys) {
        [customEvent setStringProperty:customData[key] forKey:key];
    }
    [customEvent setNumberProperty:@(duration) forKey:@"dwell_time"];
    
    // Record the event in analytics
    [customEvent track];
}
```

**Swift**
```swift
func didCheck(intoFence fence: BDFenceInfo!, 
              inZone zoneInfo: BDZoneInfo!, 
              atLocation location: BDLocationInfo!, 
              willCheckOut: Bool, 
              withCustomData customData: [AnyHashable : Any]!) {
    let customEvent = UACustomEvent(name: "bluedot_place_entered")
    customEvent.interactionType = "location"
    customEvent.interactionID = zone.id

    // Set custom event properties
    customEvent.setStringProperty(zone.name, forKey: "bluedot_zone_name")  
    customData?.forEach { (elem) in
        customEvent.setStringProperty("\(elem.value)", forKey: "\(elem.key)")
    }

    // Record the event in analytics
    customEvent.track()
}

func didCheckOut(fromFence fence: BDFenceInfo!, 
                 inZone zoneInfo: BDZoneInfo!, 
                 on date: Date!, 
                 withDuration checkedInDuration: UInt, 
                 withCustomData customData: [AnyHashable : Any]!) {
    let customEvent = UACustomEvent(name: "bluedot_place_exited")
    customEvent.interactionType = "location"
    customEvent.interactionID = zone.id

    // Set custom event properties
    customEvent.setStringProperty(zone.name, forKey: "bluedot_zone_name")
    customData?.forEach { (elem) in
        customEvent.setStringProperty("\(elem.value)", forKey: "\(elem.key)")
    }
    if let dwellTime = dwellTime {
        customEvent.setNumberProperty(NSNumber(value: dwellTime), forKey: "dwell_time")
    }

    // Record the event in analytics
    customEvent.track()
}
```

## Next steps
Full documentation can be found at https://docs.bluedot.io/ios-sdk/ and https://docs.airship.com/platform/ios/ respectivelly.

