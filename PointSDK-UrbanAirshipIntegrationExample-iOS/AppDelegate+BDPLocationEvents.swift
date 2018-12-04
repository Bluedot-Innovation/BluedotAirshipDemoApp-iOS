//
//  BDPLocationEvents.swift
//  PointSDK-UrbanAirshipIntegrationExample-iOS
//
//  Created by Pavel Oborin on 8/11/18.
//  Copyright © 2018 Jason Xie. All rights reserved.
//

import Foundation
import BDPointSDK
import AirshipKit

class BDUACustomEvent: UACustomEvent {
    convenience init(zone: BDZoneInfo, fence: BDFenceInfo!, customData: [AnyHashable : Any]?, dwellTime: UInt? = nil) {
        // 
        let name = dwellTime == nil ? "bluedot_place_entered" : "bluedot_place_exited"
        
        self.init(name: name)
        self.interactionType = "location"
        self.interactionID = zone.id
        self.setStringProperty(zone.name, forKey: "bluedot_zone_name")
        
        customData?.forEach { (elem) in
            self.setStringProperty("\(elem.value)", forKey: "\(elem.key)")
        }
        
        if let dwellTime = dwellTime {
            self.setNumberProperty(NSNumber(value: dwellTime), forKey: "dwell_time")
        }
    }
}

extension AppDelegate: BDPLocationDelegate {
    func didCheck(intoFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, atLocation location: BDLocationInfo!, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!) {

        let event = BDUACustomEvent(zone: zoneInfo, fence: fence, customData: customData)
        event.track()
    }
    
    func didCheckOut(fromFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]!) {
        
        let event = BDUACustomEvent(zone: zoneInfo, fence: fence, customData: customData, dwellTime: checkedInDuration)
        event.track()
    }
    
    func didCheck(intoBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, atLocation locationInfo: BDLocationInfo!, with proximity: CLProximity, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!) {
        
    }
    
    func didCheckOut(fromBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, with proximity: CLProximity, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]!) {
        
    }
}
