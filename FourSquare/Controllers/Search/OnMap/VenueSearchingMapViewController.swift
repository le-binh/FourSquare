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
import RealmSwift

class VenueSearchingMapViewController: MapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadVenuesFromRealm()
    }

    func searchVenues(name: String, address: String) {
        SVProgressHUD.show()
        VenueService().searchVeues(address, query: name, limit: 10, offset: 0) { (venues) in
            SVProgressHUD.dismiss()
            self.loadVenuesFromRealm()
        }
    }

    private func loadVenuesFromRealm() {
        do {
            let realm = try Realm()
            self.venues = realm.objects(Venue).filter("section = 'search'")
        } catch {
            print("Realm Have Error!!")
        }
    }
}
