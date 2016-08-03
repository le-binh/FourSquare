//
//  VenueTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/3/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    @IBOutlet weak var nameVenueLabel: UILabel!
    @IBOutlet weak var rattingVenueLabel: UILabel!
    @IBOutlet weak var addressStreetVenueLabel: UILabel!
    @IBOutlet weak var addressCityVenueLabel: UILabel!
    @IBOutlet weak var nameCategoryVenueLabel: UILabel!
    @IBOutlet weak var priceVenueLabel: UILabel!
    @IBOutlet weak var distanceVenueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
