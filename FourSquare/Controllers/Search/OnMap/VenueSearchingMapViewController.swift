//
//  MapSearchViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/9/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD

class VenueSearchingMapViewController: MapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func searchVenues(name: String, address: String) {
        SVProgressHUD.show()
        VenueService().searchVeues(address, query: name, limit: 10, offset: 0) { (venues) in
            SVProgressHUD.dismiss()
            self.venues = venues
        }
    }
}
