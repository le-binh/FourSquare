//
//  MyLocationManager.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/15/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MyLocationManager: NSObject {
    static let sharedInstanced = MyLocationManager()
    let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var isFirstUpdate: Bool = true

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter = 100
        self.locationManager.pausesLocationUpdatesAutomatically = true
    }

    func startLocation() {
        self.locationManager.startUpdatingLocation()
    }

}

// MARK:- LocationManager Delegate

extension MyLocationManager: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.currentLocation = self.locationManager.location
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        if self.currentLocation != nil && self.isFirstUpdate {
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationCenterKey.loadVenue, object: nil)
            self.isFirstUpdate = false
        }
        self.locationManager.stopUpdatingLocation()
    }
}
