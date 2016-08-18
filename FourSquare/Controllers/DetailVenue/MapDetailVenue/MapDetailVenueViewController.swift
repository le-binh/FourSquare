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
    var routePolyline: GMSPolyline!
    var paddingMap: CGFloat = 30

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar?.title = venue?.name
        self.configureFavoriteButton()
        self.setUpUI()
        self.addMarker()
        self.setUpData()
        self.setUpMyLocationManager()
        self.drawRouteGoogleMaps()
    }

    override func favoriteAction(sender: AnyObject) {
        super.favoriteAction(sender)
        guard let venue = self.venue else { return }
        if didAddFavorite {
            RealmManager.sharedInstance.deleteFavorite(venue.id)
        } else {
            RealmManager.sharedInstance.addFavorite(venue.id)
        }
        didAddFavorite = !didAddFavorite }

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

    private func configureFavoriteButton() {
        if let venue = self.venue {
            self.didAddFavorite = venue.didFavorite
        }
    }

    private func addMarker() {
        let path = GMSMutablePath()
        if let venue = self.venue {
            let marker = MarkerMap()
            let latitude = venue.location?.latitude ?? 0
            let longitude = venue.location?.longitude ?? 0
            marker.position = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
            marker.icon = UIImage(named: "selected_marker_ic")
            marker.map = self.googleMapView
            path.addCoordinate(marker.position)
            self.googleMapView.camera = GMSCameraPosition(target: marker.position, zoom: marker.zoomLevelMarker, bearing: 0, viewingAngle: 0)
            guard let currentLoction = MyLocationManager.sharedInstanced.currentLocation else {
                return
            }
            let positionDefault = currentLoction.coordinate
            path.addCoordinate(positionDefault)
            let bounds: GMSCoordinateBounds = GMSCoordinateBounds(path: path)
            if path.count() == 1 {
                return
            }
            self.googleMapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: paddingMap))
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

    private func setUpMyLocationManager() {
        self.googleMapView.myLocationEnabled = true
    }

    private func drawRouteGoogleMaps() {
        guard let currentLocation = MyLocationManager.sharedInstanced.currentLocation else { return }
        let currentLocationCoord = currentLocation.coordinate
        guard let venue = self.venue else { return }
        guard let venueLocation = venue.location else { return }
        let venueLocationCoord = CLLocationCoordinate2D(latitude: CLLocationDegrees(venueLocation.latitude), longitude: CLLocationDegrees(venueLocation.longitude))
        GoogleDirectionService().addOverlayToMapView(currentLocationCoord, venueLocationCoord: venueLocationCoord) { (encodedString) in
            self.addPolyLineWithEncodedString(encodedString)
        }
    }

    private func addPolyLineWithEncodedString(encodedString: String) {
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeWidth = 3
        polyLine.strokeColor = Color.Orange253
        polyLine.map = self.googleMapView
    }
}
