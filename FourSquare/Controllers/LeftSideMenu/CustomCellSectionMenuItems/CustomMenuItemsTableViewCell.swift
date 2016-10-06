//
//  CustomMenuItemsTableViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class CustomMenuItemsTableViewCell: UITableViewCell {
    @IBOutlet private weak var menuItemTitleLable: UILabel!
    @IBOutlet private weak var menuItemsActiveSwitch: UISwitch!

    var itemMenu: ItemMenu = ItemMenu()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        self.setupUI()
    }

    @IBAction func getActiveOfItem(sender: AnyObject) {
        if self.menuItemsActiveSwitch.on {
            self.itemMenu.active = true
        } else {
            self.itemMenu.active = false
        }
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationCenterKey.updateItemsMenu, object: nil, userInfo: [NotificationCenterUserInfo.menuItem: self.itemMenu])
    }

    func setupUI() {
        self.setHeightForSwitch()
    }

    func setHeightForSwitch() {
        self.menuItemsActiveSwitch.transform = CGAffineTransformMakeScale(0.6, 0.6)
    }

    func configureCell(item: MenuItemsSlide) {
        self.menuItemTitleLable.text = item.title
        self.itemMenu.item = item
    }

}

class ItemMenu: NSObject {
    var item: MenuItemsSlide
    var active: Bool

    init(item: MenuItemsSlide, active: Bool) {
        self.item = item
        self.active = active
    }

    override convenience init() {
        let item: MenuItemsSlide = .Drinks
        self.init(item: item, active: false)
    }
}
