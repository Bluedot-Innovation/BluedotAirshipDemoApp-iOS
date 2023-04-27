//
//  ViewController.swift
//  AirshipSDKTest
//

import UIKit
import MapKit
import BDPointSDK

let bluedotProjectId = "YourProjectId"

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var initializeSDKButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    @IBAction func startGeoTriggering(_ sender: UIButton) {
        BDLocationManager.instance()?.startGeoTriggering() {
            error in
            guard error == nil else {
                print("Bluedot Point SDK: Start GeoTriggering Error: \(String(describing: error?.localizedDescription))")
                return
            }
            print( "Bluedot Point SDK - GeoTriggering started" )
        }
    }
    
    @IBAction func stopGeoTriggering(_ sender: UIButton) {
        BDLocationManager.instance()?.stopGeoTriggering() {
            error in
            guard error == nil else {
                print("Bluedot Point SDK: Stop GeoTriggering Error: \(String(describing: error?.localizedDescription))")
                return
            }
            print( "Bluedot Point SDK - GeoTriggering stopped" )
        }
    }
    
    @IBAction func initializeSDK(_ sender: UIButton) {
        if BDLocationManager.instance()?.isInitialized() == false {
            BDLocationManager.instance()?.initialize(
                withProjectId: bluedotProjectId) { error in
                guard error == nil else {
                    print("Bluedot Point SDK: Initialisation Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                print( "Bluedot Point SDK: Initialised successfully with SDK" )
                BDLocationManager.instance()?.requestAlwaysAuthorization()
            }
        }
    }
    
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if case BDLocationManager.instance()?.isInitialized() = false {
            mapView.setCenter(CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), animated: true)
        }
    }
}
