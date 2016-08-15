//
//  MapDetailVenueCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/7/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class MapDetailVenueCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    var detailVenueViewController: DetailVenueViewController?
    var venue: Venue? {
        didSet {
            guard let venue = self.venue else { return }
            self.addressLabel.text = venue.location?.fullAddress
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func mapDetailVenueAction(sender: AnyObject) {
        let mapDetailVenueViewController = MapDetailVenueViewController.vc()
        mapDetailVenueViewController.venue = venue
        self.detailVenueViewController?.navigationController?.pushViewController(mapDetailVenueViewController, animated: true)
    }

}
