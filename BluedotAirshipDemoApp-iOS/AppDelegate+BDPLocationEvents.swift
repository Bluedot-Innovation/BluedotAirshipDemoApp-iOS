//
//  AppDelegate+BDPLocationEvents.swift
//  BluedotAirshipDemoApp-iOS
//

import Foundation
import BDPointSDK
import AirshipKit

extension CustomEvent {
    convenience init(zone: BDZoneInfo, fence: BDFenceInfo!, dwellTime: UInt? = nil) {
        // Can customize to any event name or attribute
        // here are just examples to log custom events to Airship when checkin and checkout happen
        let name = dwellTime == nil ? "bluedot_place_entered" : "bluedot_place_exited"
        
        self.init(name: name)
        self.interactionType = "location"
        self.interactionID = zone.id
        
        var bluedotProperties = Dictionary<String, String>()
        zone.customData?.forEach {
            (key, value) in bluedotProperties[key] = value
        }
        bluedotProperties["bluedot_zone_name"] = zone.name

        if let dwellTime = dwellTime {
            bluedotProperties["dwell_time"] = NSNumber(value: dwellTime).stringValue
        }
        
        self.properties = bluedotProperties
    }
}

extension AppDelegate: BDPGeoTriggeringEventDelegate {
    
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
