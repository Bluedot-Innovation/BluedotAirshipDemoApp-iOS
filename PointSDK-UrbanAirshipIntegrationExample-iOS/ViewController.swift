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

let ApiKeyProperty = "bluedotApiKey"

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var authenticateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        BDLocationManager.instance()?.sessionDelegate = self
    }
    
    @IBAction func authenticatePointSDK(_ sender: UIButton) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: ApiKeyProperty) as? String else {
            return
        }
        
        switch BDLocationManager.instance()!.authenticationState {
        case .authenticated:
            BDLocationManager.instance()?.logOut()
            
        case .notAuthenticated:
            BDLocationManager.instance()?.authenticate(withApiKey: apiKey, requestAuthorization: .authorizedAlways)
            
        default:
            return
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if case BDLocationManager.instance()?.authenticationState = BDAuthenticationState.notAuthenticated {
            let span = MKCoordinateSpan(latitudeDelta: (userLocation.location?.horizontalAccuracy ?? 0) / 30000, longitudeDelta: (userLocation.location?.verticalAccuracy ?? 0) / 30000)
            mapView.setRegion(MKCoordinateRegion(center: userLocation.coordinate, span: span), animated: true)
        }
    }
}

extension ViewController: BDPointDelegate {
    func willAuthenticate(withApiKey apiKey: String!) {
        
    }
    
    func authenticationWasSuccessful() {
        authenticateButton.setTitle("Logout", for: .normal)
    }
    
    func authenticationWasDenied(withReason reason: String!) {
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func authenticationFailedWithError(_ error: Error!) {
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func didEndSession() {
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
    
    func didEndSessionWithError(_ error: Error!) {
        authenticateButton.setTitle("Authenticate", for: .normal)
    }
}
