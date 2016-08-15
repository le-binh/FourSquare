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
        self.locationManager.requestAlwaysAuthorization()
    }

}

extension MyLocationManager: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.currentLocation = newLocation
    }
}
