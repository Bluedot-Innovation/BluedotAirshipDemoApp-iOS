//
//  ViewController.swift
//  UrbanAirshipSDKTest
//
//  Created by Jason Xie on 11/05/2016.
//  Copyright © 2016 Jason Xie. All rights reserved.
//

import UIKit
import MapKit
import BluedotPointSDK_UrbanAirship

enum AppState: String {
    case notAuthenticated = "Not Authenticated"
    case authenticated = "Authenticated"
    case checkInTriggered = "Check in triggered"
    case checkOutTriggered = "Check out triggered"
    case pushMessageReceived = "Push message received"
}

class ViewController: UIViewController
{
    var state: AppState!
    {
        didSet {
            stateLabel.text = state.rawValue
        }
    }
    
    var latestCheckIn: CheckIn?
    {
        didSet {
            fenceNameLabel.text = latestCheckIn?.fenceName ?? "N/A"
            zoneNameLabel.text = latestCheckIn?.zoneName ?? "N/A"
            if let latestCheckIn = latestCheckIn
            {
                mapView.addAnnotation(latestCheckIn)
                mapView.setCenter(latestCheckIn.coordinate, animated: true)
                checkIns.append(latestCheckIn)
            }
        }
    }
    
    var checkIns: [CheckIn] = []
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var fenceNameLabel: UILabel!
    @IBOutlet weak var zoneNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        state = .notAuthenticated
        
        mapView.delegate = self
        UAirship.push().pushNotificationDelegate = self
        UABluedotLocationServiceAdapter.shared().delegate = self
        
        resetCheckIns()
    }
    
    @IBAction func authenticatePointSDK(_ sender: UIButton)
    {
        let locationServiceAdapter = UABluedotLocationServiceAdapter.shared()
        if case .notAuthenticated = state!
        {
            locationServiceAdapter?.authenticate()
            sender.setTitle("Logout", for: .normal)
        }
        else
        {
            locationServiceAdapter?.logout()
            sender.setTitle("Authenticate", for: .normal)
        }
    }
}

extension ViewController
{
    func resetCheckIns() {
        mapView.removeAnnotations(checkIns)
        checkIns = []
        latestCheckIn = nil
    }
}

extension ViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if case .notAuthenticated = state!
        {
            let span = MKCoordinateSpanMake((userLocation.location?.horizontalAccuracy ?? 0) / 30000, (userLocation.location?.verticalAccuracy ?? 0) / 30000)
            mapView.setRegion(MKCoordinateRegionMake(userLocation.coordinate, span), animated: true)
        }
    }
}

extension ViewController: UAPushNotificationDelegate
{
    func receivedForegroundNotification(_ notification: [AnyHashable : Any])
    {
        state = .pushMessageReceived
        
        let alertMessage = notification["alert"] as! String
        
        if let latestCheckIn = latestCheckIn
        {
            let alert = UIAlertController(title: "Lastest trigger: \(latestCheckIn.fenceName) in \(latestCheckIn.zoneName)", message: alertMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func receivedBackgroundNotification(_ notification: [AnyHashable : Any])
    {
        state = .pushMessageReceived
        
        let alertMessage = notification["alert"] as! String
        
        if let latestCheckIn = latestCheckIn
        {
            let alert = UIAlertController(title: "Lastest trigger: \(latestCheckIn.fenceName) in \(latestCheckIn.zoneName)", message: alertMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }

    }
}

extension ViewController: UABluedotLocationServiceAdapterDelegate
{
    func didCheck(intoFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, atLocation location: BDLocationInfo!, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!, withTags tags: [String]!) {
        state = .checkInTriggered
        
        let checkIn = CheckIn(fenceName: fence.name, zoneName: zoneInfo.name, triggeredTime: location.timestamp, coordinate: CLLocationCoordinate2DMake(location.latitude, location.longitude))
        latestCheckIn = checkIn
    }
    
    func didCheckOut(fromFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, withDuration checkedInDuration: UInt, withCustomData customData: [NSObject : AnyObject]!, withTags tags: [String]!)
    {
        state = .checkOutTriggered
    }
    
    func didAuthenticate()
    {
        state = .authenticated
    }
    
    func didLogout()
    {
        state = .notAuthenticated
        resetCheckIns()
    }

}

