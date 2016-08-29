//
//  LoginTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class LoginTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
