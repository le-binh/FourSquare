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
        SVProgressHUD.setDefaultMaskType(.Clear)
        self.deleteVenues()
        VenueService().searchVeues(address, query: name) { (error) in
            SVProgressHUD.dismiss()
            self.clearMapData()
            self.addMultiMarker()
            self.venueCollectionView.reloadData()
            self.configureChangeCellButton(0)
        }
    }

    private func loadVenuesFromRealm() {
        self.venues = RealmManager.sharedInstance.getSearchVenues()
    }

    private func deleteVenues() {
        RealmManager.sharedInstance.clearSection("search")
    }
}
