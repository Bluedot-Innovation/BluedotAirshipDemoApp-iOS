//
//  CheckIn.swift
//  UrbanAirshipSDKTest
//
//  Created by Jason Xie on 19/05/2016.
//  Copyright © 2016 Jason Xie. All rights reserved.
//

import Foundation

private let dateFormatter: DateFormatter =
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
    return dateFormatter
}()

class CheckIn: NSObject, MKAnnotation {
    var title: String?
    {
        get
        {
            return fenceName
        }
    }
    var subtitle: String?
    {
        get
        {
            return dateFormatter.string(from: triggeredTime)
        }
    }
    var coordinate: CLLocationCoordinate2D
    var fenceName: String
    var zoneName: String
    var triggeredTime: Date
    
    init(fenceName: String, zoneName: String, triggeredTime: Date, coordinate: CLLocationCoordinate2D) {
        self.fenceName = fenceName
        self.zoneName = zoneName
        self.coordinate = coordinate
        self.triggeredTime = triggeredTime
    }
}
