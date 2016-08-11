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

    @IBOutlet weak var venueContentView: UIView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameVenueLabel: UILabel!
    @IBOutlet weak var addressVenueLabel: UILabel!
    @IBOutlet weak var ratingVenueLabel: UILabel!
    @IBOutlet weak var categoryVenueLabel: UILabel!
    @IBOutlet weak var priceVenueLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

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
            self.distanceLabel.text = "\(distance)m From Here"
        }
        if let url = venue.thumbnailPath {
            self.thumbnailImageView.hnk_setImageFromURL(url)
        }
    }

}
