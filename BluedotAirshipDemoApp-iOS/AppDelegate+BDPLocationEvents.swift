//
//  BDPLocationEvents.swift
//  BluedotAirshipDemoApp-iOS
//
//  Created by Pavel Oborin on 8/11/18.
//  Copyright © 2018 Jason Xie. All rights reserved.
//

import Foundation
import BDPointSDK
import Airship

class BDUACustomEvent: UACustomEvent {
    convenience init(zone: BDZoneInfo, fence: BDFenceInfo!, dwellTime: UInt? = nil) {
        // 
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
        let event = BDUACustomEvent(zone: enterEvent.zone(), fence: enterEvent.fence)
        event.track()
    }
    
    func didExitZone(_ exitEvent: BDZoneExitEvent) {
        print("Exited zone: \(String(describing: exitEvent.zone().name))")
        let event = BDUACustomEvent(zone: exitEvent.zone(), fence: exitEvent.fence, dwellTime: exitEvent.duration)
        event.track()
    }
}
