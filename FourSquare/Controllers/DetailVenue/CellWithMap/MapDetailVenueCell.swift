//
//  MapDetailVenueCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/7/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

protocol MapDetailVenueCellDelegate: NSObjectProtocol {
    func showMapDetailVenue()
}
class MapDetailVenueCell: UITableViewCell {
    @IBOutlet private weak var addressLabel: UILabel!
    var venue: Venue? {
        didSet {
            self.addressLabel.text = venue?.location?.fullAddress
        }
    }
    weak var delegate: MapDetailVenueCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func mapDetailVenueAction(sender: AnyObject) {
        self.delegate?.showMapDetailVenue()
    }

}
