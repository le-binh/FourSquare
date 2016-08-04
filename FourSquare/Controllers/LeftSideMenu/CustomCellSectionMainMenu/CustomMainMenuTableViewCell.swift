//
//  CustomMainMenuTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class CustomMainMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    func configureCell(title: String, icon: UIImage) {
        self.menuTitleLabel.text = title
        self.menuIconImageView.image = icon
    }

}
