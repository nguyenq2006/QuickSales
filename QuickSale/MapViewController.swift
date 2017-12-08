//
//  MapViewController.swift
//  QuickSale
//
//  Created by CS on 12/6/17.
//  Copyright © 2017 Quoc Nguyen. All rights reserved.
// source: https://stackoverflow.com/questions/44824856/how-to-get-location-within-the-camera-use-in-swift-3-4
//

import UIKit
import Foundation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    static var locationManager:CLLocationManager = CLLocationManager()
    static var markers = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapViewController.locationManager.delegate = self
        MapViewController.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        MapViewController.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            DispatchQueue.main.async {
                MapViewController.locationManager.startUpdatingLocation()
            }
        } else {
            MapViewController.locationManager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapZoomIn()
        }
        addItemToMap()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                MapViewController.locationManager.startUpdatingLocation()
            }
            mapZoomIn()
            break
        default:
            manager.requestWhenInUseAuthorization()
            break
        }
    }
    
    func mapZoomIn() {
        let current = MapViewController.locationManager.location
        let noLocation = CLLocationCoordinate2D(latitude: (current?.coordinate.latitude)!, longitude: (current?.coordinate.longitude)!)
        let viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 12000, 12000)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    func addItemToMap(){
        for marker in MapViewController.markers{
           self.mapView.addAnnotation(marker)
        }
    }
    
}
