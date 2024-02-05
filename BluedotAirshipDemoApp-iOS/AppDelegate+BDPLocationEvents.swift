//
//  AppDelegate+BDPLocationEvents.swift
//  BluedotAirshipDemoApp-iOS
//

import Foundation
import BDPointSDK
import AirshipCore

extension CustomEvent {
    convenience init(zone: ZoneInfo, dwellTime: TimeInterval? = nil) {
        // Can customize to any event name or attribute
        // here are just examples to log custom events to Airship when checkin and checkout happen
        let name = dwellTime == nil ? "bluedot_place_entered" : "bluedot_place_exited"
        
        self.init(name: name)
        self.interactionType = "location"
        self.interactionID = zone.id.uuidString
        
        var bluedotProperties = Dictionary<String, String>()
        zone.customData.forEach {
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
    
    func didEnterZone(_ triggerEvent: GeoTriggerEvent) {
        print("Entered zone: \(String(describing: triggerEvent.zoneInfo.name))")
        let event = CustomEvent(zone: triggerEvent.zoneInfo)
        event.track()
    }
    
    func didExitZone(_ triggerEvent: GeoTriggerEvent) {
        print("Exited zone: \(String(describing: triggerEvent.zoneInfo.name))")
        let event = CustomEvent(zone: triggerEvent.zoneInfo, dwellTime: triggerEvent.exitEvent?.dwellTime)
        event.track()
    }
}
