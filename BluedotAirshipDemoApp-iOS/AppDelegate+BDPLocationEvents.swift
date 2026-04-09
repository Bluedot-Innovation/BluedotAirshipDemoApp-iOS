//
//  AppDelegate+BDPLocationEvents.swift
//  BluedotAirshipDemoApp-iOS
//

import Foundation
import BDPointSDK
import AirshipCore

extension CustomEvent {
    init(zone: ZoneInfo, dwellTime: TimeInterval? = nil) {
        // Can customize to any event name or attribute
        // here are just examples to log custom events to Airship when checkin and checkout happen
        let name = dwellTime == nil ? "bluedot_place_entered" : "bluedot_place_exited"
        
        self.init(name: name)
        self.interactionType = "location"
        self.interactionID = zone.id.uuidString
        
        var props : [String: AirshipJSON] = [:]
        
        for (key, value) in zone.customData {
            props[key] = AirshipJSON.string(value)
        }
        
        
        props["bluedot_zone_name"] = AirshipJSON.string(zone.name)

        if let dwellTime = dwellTime {
            props["dwell_time"] =  AirshipJSON.number(dwellTime)
        }
        
        do {
            try self.setProperties(props)
        } catch {
            print("Failed to set Airship event properties: \(error)")
        }
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
