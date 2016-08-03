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

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultMenuItems()

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
            guard let defaultMenuItem = DefaultMenuItem(rawValue: i) else {
                continue
            }
            pageViewController.title = defaultMenuItem.title
            pageViewController.titleOfMenu = defaultMenuItem.title
            self.itemViewControllers.append(pageViewController)
        }
    }

    private func setupMenuPage() {
        let parameters: [CAPSPageMenuOption] = [.MenuItemSeparatorWidth(4.3),
                .UseMenuLikeSegmentedControl(true),
                .MenuItemSeparatorPercentageHeight(0.1)]
        self.pageMenu = CAPSPageMenu(viewControllers: self.itemViewControllers, frame: CGRect(x: 0, y: 64, width: kScreenSize.width, height: kScreenSize.height), pageMenuOptions: parameters)
        if let pageMenu = self.pageMenu {
            self.view.addSubview(pageMenu.view)
        }
    }

}
