//
//  VenueItemTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import Haneke

class VenueItemTableViewCell: UITableViewCell {

    // MARK:- Properties

    @IBOutlet private weak var venueContentView: UIView!
    @IBOutlet private weak var verifiedImageView: UIImageView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameVenueLabel: UILabel!
    @IBOutlet private weak var addressVenueLabel: UILabel!
    @IBOutlet private weak var ratingVenueLabel: UILabel!
    @IBOutlet private weak var categoryVenueLabel: UILabel!
    @IBOutlet private weak var priceVenueLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!

    // MARK:- Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
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
        self.thumbnailImageView.image = UIImage(named: "image_loading")
        self.verifiedImageView.image = (venue.verified) ? UIImage(named: "verified_ic") : UIImage(named: "not_verified_ic")
        self.nameVenueLabel.text = venue.name
        self.addressVenueLabel.text = venue.location?.fullAddress
        self.ratingVenueLabel.text = "\(venue.rating)"
        self.ratingVenueLabel.backgroundColor = venue.ratingColor
        self.categoryVenueLabel.text = venue.showCategories
        self.priceVenueLabel.text = venue.price?.showCurrency()
        if let distance = venue.location?.distance {
            self.distanceLabel.text = "\(distance)m From Here"
        } else {
            self.distanceLabel.text = "???m From Here"
        }
        if let url = venue.thumbnail?.thumbnailPath {
            self.thumbnailImageView.hnk_setImageFromURL(url)
        }
    }

}
