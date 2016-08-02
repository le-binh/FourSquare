//
//  CustomMenuItemsTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class CustomMenuItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var menuItemTitleLable: UILabel!
    @IBOutlet weak var menuItemsActiveSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setHeightForSwitch()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setHeightForSwitch() {
        self.menuItemsActiveSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7)
    }

    func setUI(title: String) {
        self.menuItemTitleLable.text = title
    }

}
