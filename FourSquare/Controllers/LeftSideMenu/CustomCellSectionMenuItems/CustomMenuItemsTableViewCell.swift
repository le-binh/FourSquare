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

    var itemMenu = ItemMenu(item: MenuItemsSlide(rawValue: 0)!, active: false)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setHeightForSwitch()
        self.menuItemsActiveSwitch.addTarget(self, action: #selector(self.getActiveOfItem), forControlEvents: .ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setHeightForSwitch() {
        self.menuItemsActiveSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7)
    }

    func setUI(item: MenuItemsSlide) {
        self.menuItemTitleLable.text = item.title
        self.itemMenu.item = item
    }

    func getActiveOfItem() {
        if self.menuItemsActiveSwitch.on {
            self.itemMenu.active = true
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeItem", object: nil, userInfo: ["item": self.itemMenu])
        } else {
            self.itemMenu.active = false
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeItem", object: nil, userInfo: ["item": self.itemMenu])
        }
    }

}

class ItemMenu: AnyObject {
    var item: MenuItemsSlide = MenuItemsSlide(rawValue: 0)!
    var active: Bool = false

    init(item: MenuItemsSlide, active: Bool) {
        self.item = item
        self.active = active
    }
}
