//
//  BackgroundViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/1/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import LGSideMenuController
import SwiftUtils

class BackgroundViewController: LGSideMenuController {

    var leftViewController = LeftSideMenuViewController()

    var allMenuItems: [ItemMenu] = []

    var activeMenuItems: [ItemMenu] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftViewSwipeGestureEnabled = false
        for i in 0..<6 {
            guard let menuItem = MenuItemsSlide(rawValue: i) else {
                continue
            }
            let item = ItemMenu(item: menuItem, active: false)
            allMenuItems.append(item)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateItem), name: NotificationCenterKey.updateItemsMenu, object: nil)
    }

    func loadMenuView(initWithRootViewController: UIViewController, style: LGSideMenuPresentationStyle) {

        let leftSlideViewWidth = kScreenSize.width * (2 / 3)
        super.rootViewController = initWithRootViewController
        leftViewController = LeftSideMenuViewController.vc()
        self.setLeftViewEnabledWithWidth(leftSlideViewWidth, presentationStyle: style, alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions.OnNone)
        self.leftViewStatusBarStyle = UIStatusBarStyle.Default
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions.OnNone
        self.leftViewBackgroundColor = Color.Brown62
        leftViewController.view.backgroundColor = UIColor.clearColor()
        self.leftView().addSubview(leftViewController.view)

    }

    override func leftViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.leftViewWillLayoutSubviewsWithSize(size)
        leftViewController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

    func updateItem(notification: NSNotification) {
        if let infoUser = notification.userInfo {
            if let item = infoUser[NotificationCenterUserInfo.menuItem] as? ItemMenu {
                self.allMenuItems[item.item.rawValue] = item
            }
        }

        self.activeMenuItems = self.allMenuItems.filter({
            $0.active == true
        })
    }

}
