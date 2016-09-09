//
//  DefaultVenueDetailCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/6/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class DefaultVenueDetailCell: UITableViewCell {
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var textDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
