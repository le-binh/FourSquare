//
//  HomeViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/1/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import PageMenu
import SwiftUtils
import LGSideMenuController

enum DefaultMenuItem: Int {
    case TopPicks
    case Food
    case Shops

    var title: String {
        switch self {
        case .TopPicks:
            return Strings.MenuItemTopPicks
        case .Food:
            return Strings.MenuItemFood
        case .Shops:
            return Strings.MenuItemShops
        }
    }
}

class HomeViewController: BaseViewController {

    @IBOutlet weak var viewOfPageMenu: UIView!

    // MARK:- Properties

    var pageMenu: CAPSPageMenu?
    var itemViewControllers: [UIViewController] = []
    var activeMenuItems: [ItemMenu] = []

    // MARK:- Life Cycle

    override func viewDidLoad() {
        self.title = Strings.HomeTitle
        super.viewDidLoad()
        self.itemViewControllers = self.setDefaultMenuItems()
        self.setUpMenuPage(isDefault: true)
        self.setUpNotificationCenter()
    }

    // MARK:- Public Functions

    // MARK:- Private Function

    private func setDefaultMenuItems() -> [UIViewController] {

        var viewControllers: [UIViewController] = []

        for i in 0..<3 {
            let pageViewController = MenuItemViewController.vc()
            guard let defaultItemMenu = DefaultMenuItem(rawValue: i) else {
                continue
            }
            pageViewController.title = defaultItemMenu.title
            pageViewController.defaultItem = defaultItemMenu
            viewControllers.append(pageViewController)
        }
        return viewControllers
    }

    private func setUpMenuPage(isDefault isDefault: Bool) {
        let parameters: [CAPSPageMenuOption] = parametersOfPageMenu(isDefault)
        self.pageMenu = CAPSPageMenu(viewControllers: self.itemViewControllers, frame: self.viewOfPageMenu.frame, pageMenuOptions: parameters)
        if let pageMenu = self.pageMenu {
            self.view.addSubview(pageMenu.view)
        }

    }

    private func parametersOfPageMenu(isDefault: Bool) -> [CAPSPageMenuOption] {
        let menuItemPadding: CGFloat = 5
        var numberOfItemWillShowOnMenu: CGFloat = 3
        if !isDefault {
            numberOfItemWillShowOnMenu = 3.5
        }
        let menuItemWidth = (kScreenSize.width - 4 * menuItemPadding) / numberOfItemWillShowOnMenu
        let menuHeight: CGFloat = 35
        let parameters: [CAPSPageMenuOption] = [.MenuHeight(menuHeight),
                .MenuMargin(menuItemPadding),
                .MenuItemWidth(menuItemWidth),
                .ScrollMenuBackgroundColor(Color.Gray235),
                .SelectionIndicatorColor(Color.Orange253),
                .SelectedMenuItemLabelColor(Color.Orange253)]
        return parameters

    }

    private func setUpNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.dismissLeftSideMenu), name: kLGSideMenuControllerWillDismissLeftViewNotification, object: nil)
    }

    @objc private func dismissLeftSideMenu() {
        let newActiveMenuItems = BackgroundViewController.sharedInstance.activeMenuItems
        let isChangeActiveMenuItems = self.compareTwoArray(self.activeMenuItems, newArray: newActiveMenuItems)
        if !isChangeActiveMenuItems {
            self.changeMenuItems(newActiveMenuItems)
        }
    }

    private func changeMenuItems(newActiveMenuItems: [ItemMenu]) {
        self.activeMenuItems = newActiveMenuItems
        self.itemViewControllers = self.setDefaultMenuItems()
        self.addActiveMenuItems()
        self.setUpNewActiveMenuItems()
    }

    private func addActiveMenuItems() {
        for i in 0..<self.activeMenuItems.count {
            let pageViewController = MenuItemViewController.vc()
            guard let activeMenuItem: MenuItemsSlide = self.activeMenuItems[i].item else {
                continue
            }
            pageViewController.title = activeMenuItem.title
            pageViewController.menuItem = activeMenuItem
            self.itemViewControllers.append(pageViewController)
        }
    }

    private func setUpNewActiveMenuItems() {
        if self.activeMenuItems.count == 0 {
            self.setUpMenuPage(isDefault: true)
            return
        }
        self.setUpMenuPage(isDefault: false)
    }

    private func compareTwoArray(oldArray: [ItemMenu], newArray: [ItemMenu]) -> Bool {
        if oldArray.count == newArray.count {
            for i in 0..<oldArray.count {
                if oldArray[i].item != newArray[i].item {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}
