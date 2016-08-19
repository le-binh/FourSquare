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

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    func startLocation() {
        self.locationManager.startUpdatingLocation()
    }

}

extension MyLocationManager: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.currentLocation = self.locationManager.location
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
        if self.currentLocation != nil {
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationCenterKey.loadVenue, object: nil)
        }
        self.locationManager.stopUpdatingLocation()
    }
}
