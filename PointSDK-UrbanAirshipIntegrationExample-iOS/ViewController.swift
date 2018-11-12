//
//  ViewController.swift
//  UrbanAirshipSDKTest
//
//  Created by Jason Xie on 11/05/2016.
//  Copyright © 2016 Jason Xie. All rights reserved.
//

import UIKit
import MapKit
import BDPointSDK

enum AppState: String {
    case notAuthenticated = "Not Authenticated"
    case authenticated = "Authenticated"
    case checkInTriggered = "Check in triggered"
    case checkOutTriggered = "Check out triggered"
    case pushMessageReceived = "Push message received"
}

let ApiKeyProperty = "bluedotApiKey"

class ViewController: UIViewController
{
    
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
    @IBOutlet weak var authenticateButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
        UAirship.push().pushNotificationDelegate = self
        BDLocationManager.instance()?.locationDelegate = self
        BDLocationManager.instance()?.sessionDelegate = self
        
        stateLabel.text = AppState.notAuthenticated.rawValue
        
        resetCheckIns()
    }
    
    @IBAction func authenticatePointSDK(_ sender: UIButton)
    {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: ApiKeyProperty) as? String else {
            return
        }
        
        switch BDLocationManager.instance()!.authenticationState {
        case .authenticated:
            BDLocationManager.instance()?.logOut()
            
        case .notAuthenticated:
            BDLocationManager.instance()?.authenticate(withApiKey: apiKey)
            
        default:
            return
        }
    }
}

extension ViewController {
    func resetCheckIns() {
        mapView.removeAnnotations(checkIns)
        checkIns = []
        latestCheckIn = nil
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if case BDLocationManager.instance()?.authenticationState = BDAuthenticationState.notAuthenticated {
            let span = MKCoordinateSpanMake((userLocation.location?.horizontalAccuracy ?? 0) / 30000, (userLocation.location?.verticalAccuracy ?? 0) / 30000)
            mapView.setRegion(MKCoordinateRegionMake(userLocation.coordinate, span), animated: true)
        }
    }
}

extension ViewController: UAPushNotificationDelegate {
    func receivedForegroundNotification(_ notification: [AnyHashable : Any]) {
        stateLabel.text = AppState.pushMessageReceived.rawValue
        
        let alertMessage = notification["alert"] as! String
        
        if let latestCheckIn = latestCheckIn {
            let alert = UIAlertController(title: "Lastest trigger: \(latestCheckIn.fenceName) in \(latestCheckIn.zoneName)", message: alertMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func receivedBackgroundNotification(_ notification: [AnyHashable : Any]) {
        stateLabel.text = AppState.pushMessageReceived.rawValue
        
        let alertMessage = notification["alert"] as! String
        
        if let latestCheckIn = latestCheckIn {
            let alert = UIAlertController(title: "Lastest trigger: \(latestCheckIn.fenceName) in \(latestCheckIn.zoneName)", message: alertMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: BDPointDelegate {
    func willAuthenticate(withApiKey apiKey: String!) {
        
    }
    
    func authenticationWasSuccessful() {
        stateLabel.text = AppState.authenticated.rawValue
        authenticateButton.setTitle("Logout", for: .normal)
    }
    
    func authenticationWasDenied(withReason reason: String!) {
        stateLabel.text = AppState.notAuthenticated.rawValue
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func authenticationFailedWithError(_ error: Error!) {
        stateLabel.text = AppState.notAuthenticated.rawValue
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func didEndSession() {
        stateLabel.text = AppState.notAuthenticated.rawValue
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func didEndSessionWithError(_ error: Error!) {
        stateLabel.text = AppState.notAuthenticated.rawValue
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
}
