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
        self.title = "Phố xưa"
        super.viewDidLoad()
        self.setUpUI()
        self.addMarker()
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
        self.ratingVenueLabel.backgroundColor = Color.Green125
        let radiusOfRatingLabel: CGFloat = self.ratingVenueLabel.frame.width / 2
        self.ratingVenueLabel.cornerRadiusWith(radiusOfRatingLabel)
    }

    private func addMarker() {
        let market = GMSMarker()
        market.position = CLLocationCoordinate2DMake(CLLocationDegrees(16.072157), CLLocationDegrees(108.226832))
        market.icon = UIImage(named: "selected_marker_ic")
        market.map = self.googleMapView
        self.googleMapView.camera = GMSCameraPosition(target: market.position, zoom: 14, bearing: 0, viewingAngle: 0)

    }

}
