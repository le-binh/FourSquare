//
//  VenueItemTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class VenueItemTableViewCell: UITableViewCell {

    // MARK:- Properties

    @IBOutlet weak var venueContentView: UIView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameVenueLabel: UILabel!
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
        let radiusOfVenueContentView: CGFloat = 4
        self.venueContentView.cornerRadiusWith(radiusOfVenueContentView)
        self.venueContentView.border(color: UIColor.grayColor(), width: 0.5)
        self.venueContentView.shadow(color: UIColor.redColor(), offset: CGSize(width: 5, height: 5), opacity: 0.5, radius: 1)
        self.ratingVenueLabel.backgroundColor = Color.Green125
        let radiusOfRatingLabel: CGFloat = self.ratingVenueLabel.frame.width / 2
        self.ratingVenueLabel.cornerRadiusWith(radiusOfRatingLabel)
    }

}
