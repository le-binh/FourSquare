//
//  VenueCollectionViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/8/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class VenueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameVenueLabel: UILabel!
    @IBOutlet weak var venueContentView: UIView!
    @IBOutlet weak var ratingVenueLabel: UILabel!
    @IBOutlet weak var addressVenueLabel: UILabel!
    @IBOutlet weak var categoryVenueLabel: UILabel!
    @IBOutlet weak var priceVenueLabel: UILabel!
    @IBOutlet weak var distanceVenueLabel: UILabel!
    @IBOutlet weak var thumbnailVenueImageView: UIImageView!
    @IBOutlet weak var verifiedVenueImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
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

    // MARK:- Public Functions

    func setUpData(venue: Venue) {
        self.thumbnailVenueImageView.image = UIImage(named: "image_loading")
        self.verifiedVenueImageView.image = (venue.verified) ? UIImage(named: "verified_ic") : UIImage(named: "not_verified_ic")
        self.nameVenueLabel.text = venue.name
        self.addressVenueLabel.text = venue.location?.fullAddress
        self.ratingVenueLabel.text = String(venue.rating)
        self.ratingVenueLabel.backgroundColor = venue.ratingColor
        self.categoryVenueLabel.text = venue.showCategories
        self.priceVenueLabel.text = venue.price?.showCurrency()
        if let distance = venue.location?.distance {
            self.distanceVenueLabel.text = "\(distance)m From Here"
        } else {
            self.distanceVenueLabel.text = "???m From Here"
        }
        if let url = venue.thumbnail?.thumbnailPath {
            self.thumbnailVenueImageView.hnk_setImageFromURL(url)
        }
    }
}
