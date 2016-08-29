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

    // MARK:- Singleton

    static let sharedInstance = BackgroundViewController()

    // MARK:- Properties

    var leftViewController = LeftSideMenuViewController()
    var allMenuItems: [ItemMenu] = []
    var activeMenuItems: [ItemMenu] = []

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftViewSwipeGestureEnabled = false
        self.configureAllMenuItems()
        self.setUpNotificationCenter()
    }

    override func leftViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.leftViewWillLayoutSubviewsWithSize(size)
        leftViewController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

    deinit {
        self.removeNotificationCenter()
    }

    // MARK:- Public Funtions

    func loadMenuView(initWithRootViewController: UIViewController, style: LGSideMenuPresentationStyle) {
        let leftSlideViewWidth = kScreenSize.width * (2 / 3)
        super.rootViewController = initWithRootViewController
        leftViewController = LeftSideMenuViewController.vc()
        self.setLeftViewEnabledWithWidth(leftSlideViewWidth, presentationStyle: style, alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions.OnNone)
        self.leftViewStatusBarStyle = UIStatusBarStyle.Default
        self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOptions.OnNone
        self.leftViewBackgroundColor = Color.Brown62
        leftViewController.view.backgroundColor = self.leftViewBackgroundColor
        self.leftView().addSubview(leftViewController.view)
    }

    func updateItem(notification: NSNotification) {
        if let infoUser = notification.userInfo {
            if let item = infoUser[NotificationCenterUserInfo.menuItem] as? ItemMenu {
                self.allMenuItems[item.item.rawValue] = item
            }
        }
        self.activeMenuItems = self.allMenuItems.filter({ $0.active })
    }

    func reloadSideMenu() {
        self.leftViewController.menuTableView.reloadData()
    }

    // MARK:- Private Functions

    private func setUpNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateItem), name: NotificationCenterKey.updateItemsMenu, object: nil)
    }

    private func removeNotificationCenter() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func configureAllMenuItems() {
        for i in 0..<6 {
            guard let menuItem = MenuItemsSlide(rawValue: i) else {
                continue
            }
            let item = ItemMenu(item: menuItem, active: false)
            allMenuItems.append(item)
        }
    }

}
