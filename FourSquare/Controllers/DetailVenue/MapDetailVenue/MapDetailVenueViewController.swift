//
//  MapDetailVenueViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/7/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import GoogleMaps

class MapDetailVenueViewController: BaseViewController {

    // MARK:- Properties

    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var venueContentView: UIView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameVenueLabel: UILabel!
    @IBOutlet weak var addressVenueLabel: UILabel!
    @IBOutlet weak var ratingVenueLabel: UILabel!
    @IBOutlet weak var categoryVenueLabel: UILabel!
    @IBOutlet weak var priceVenueLabel: UILabel!
    @IBOutlet weak var distanceVenueLabel: UILabel!

    var venue: Venue?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.addMarker()
        self.setUpData()
    }

    override func favoriteAction(sender: AnyObject) {
        super.favoriteAction(sender)
        didAddFavorite = !didAddFavorite
    }

    // MARK:- Private Functions

    private func setUpUI() {
        self.contentView.shadow(color: UIColor.grayColor(), offset: CGSize(width: 2, height: 2), opacity: 0.5, radius: 1)
        let radiusOfVenueContentView: CGFloat = 4
        self.venueContentView.cornerRadiusWith(radiusOfVenueContentView)
        self.venueContentView.border(color: UIColor.grayColor(), width: 0.5)
        self.ratingVenueLabel.backgroundColor = self.venue?.ratingColor
        let radiusOfRatingLabel: CGFloat = self.ratingVenueLabel.frame.width / 2
        self.ratingVenueLabel.cornerRadiusWith(radiusOfRatingLabel)
    }

    private func addMarker() {
        if let venue = self.venue {
            let market = MarkerMap()
            let latitude = venue.location?.latitude ?? 0
            let longitude = venue.location?.longitude ?? 0
            market.position = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
            market.icon = UIImage(named: "selected_marker_ic")
            market.map = self.googleMapView
            self.googleMapView.camera = GMSCameraPosition(target: market.position, zoom: market.zoomLevel, bearing: 0, viewingAngle: 0)
        }
    }

    private func setUpData() {
        if let venue = self.venue {
            self.thumbnailImageView.image = UIImage(named: "thumbnail_venue")
            self.verifiedImageView.image = (venue.verified) ? UIImage(named: "verified_ic") : UIImage(named: "not_verified_ic")
            self.nameVenueLabel.text = venue.name
            self.addressVenueLabel.text = venue.location?.fullAddress
            self.ratingVenueLabel.text = String(venue.rating)
            var categoriesName = ""
            for category in venue.categories {
                categoriesName = categoriesName + category.categoryName
            }
            self.categoryVenueLabel.text = categoriesName
            self.priceVenueLabel.text = venue.price?.showCurrency()
            if let distance = venue.location?.distance {
                self.distanceVenueLabel.text = "\(distance)m From Here"
            }
            if let url = venue.thumbnail?.thumbnailPath {
                self.thumbnailImageView.hnk_setImageFromURL(url)
            }
        }
    }

}
