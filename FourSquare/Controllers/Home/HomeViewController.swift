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

class HomeViewController: UIViewController {

    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var listOrMapMenuButton: UIButton!

    // MARK:- Properties

    var pageMenu: CAPSPageMenu?
    var itemViewControllers: [UIViewController] = []
    var activeMenuItems: [ItemMenu] = []

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultMenuItems()
        self.setUpMenuPage()
        self.setUpNotificationCenter()
    }

    // MARK:- Action

    @IBAction func showSideMenuAction(sender: AnyObject) {
        SlideMenu.getRootBackground.showHideLeftViewAnimated(true, completionHandler: nil)
    }

    @IBAction func showListOrMapAction(sender: AnyObject) {
    }

    // MARK:- Private Function

    private func setDefaultMenuItems() {
        self.itemViewControllers.removeAll()
        for i in 0..<3 {
            let pageViewController = MenuItemViewController.vc()
            guard let defaultItemMenu = DefaultMenuItem(rawValue: i) else {
                continue
            }
            pageViewController.title = defaultItemMenu.title
            pageViewController.defaultItem = defaultItemMenu
            self.itemViewControllers.append(pageViewController)
        }
    }

    private func setUpMenuPage() {
        let menuItemWidth = (kScreenSize.width - 20) / 3
        let parameters: [CAPSPageMenuOption] = [.MenuHeight(35),
                .MenuMargin(5),
                .MenuItemWidth(menuItemWidth),
                .ScrollMenuBackgroundColor(Color.Gray235),
                .SelectionIndicatorColor(Color.Orange253),
                .SelectedMenuItemLabelColor(Color.Orange253)]

        self.pageMenu = CAPSPageMenu(viewControllers: self.itemViewControllers, frame: CGRect(x: 0, y: 64, width: kScreenSize.width, height: kScreenSize.height - 64), pageMenuOptions: parameters)
        if let pageMenu = self.pageMenu {
            self.view.addSubview(pageMenu.view)
        }
    }

    private func setUpNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.dismissLeftSideMenu), name: kLGSideMenuControllerWillDismissLeftViewNotification, object: nil)
    }

    @objc private func dismissLeftSideMenu() {
        let newActiveMenuItems = BackgroundViewController.sharedInstance.activeMenuItems
        let isChangeActiveMenuItems = self.compareTwoArray(self.activeMenuItems, newArray: newActiveMenuItems)
        if !isChangeActiveMenuItems {
            self.activeMenuItems = newActiveMenuItems
            self.setDefaultMenuItems()
            for i in 0..<self.activeMenuItems.count {
                let pageViewController = MenuItemViewController.vc()
                guard let activeMenuItem: MenuItemsSlide = self.activeMenuItems[i].item else {
                    continue
                }
                pageViewController.title = activeMenuItem.title
                pageViewController.menuItem = activeMenuItem
                self.itemViewControllers.append(pageViewController)
            }
            self.setUpMenuPage()
        }
    }

    func compareTwoArray(oldArray: [ItemMenu], newArray: [ItemMenu]) -> Bool {
        if oldArray.count == newArray.count {
            for i in 0..<oldArray.count {
                if oldArray[i].item.rawValue != newArray[i].item.rawValue {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}
