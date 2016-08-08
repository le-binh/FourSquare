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
    var topPicksViewController: TopPicksViewController?
    var foodViewController: FoodViewController?
    var shopsViewController: ShopsViewController?
    var drinksViewController: DrinksViewController?
    var coffeeViewController: CoffeeViewController?
    var artsViewController: ArtsViewController?
    var outdoorsViewController: OutdoorsViewController?
    var sightsViewController: SightsViewController?
    var trendingViewController: TrendingViewController?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        self.title = Strings.HomeTitle
        super.viewDidLoad()
        self.initMenuItemViewController()
        self.itemViewControllers = self.setDefaultMenuItems()
        self.setUpMenuPage(isDefault: true)
        self.updatePageMenuItem()
        self.setUpNotificationCenter()
    }

    // MARK:- Public Functions

    // MARK:- Private Function

    func initMenuItemViewController() {
        self.topPicksViewController = TopPicksViewController.vc()
        self.foodViewController = FoodViewController.vc()
        self.shopsViewController = ShopsViewController.vc()
        self.drinksViewController = DrinksViewController.vc()
        self.coffeeViewController = CoffeeViewController.vc()
        self.artsViewController = ArtsViewController.vc()
        self.outdoorsViewController = OutdoorsViewController.vc()
        self.sightsViewController = SightsViewController.vc()
        self.trendingViewController = TrendingViewController.vc()
    }

    private func setDefaultMenuItems() -> [UIViewController] {
        // self.initMenuItemViewController()
        var viewControllers: [UIViewController] = []
        if let topPicksViewController = self.topPicksViewController {
            topPicksViewController.title = Strings.MenuItemTopPicks
            viewControllers.append(topPicksViewController)
        }
        if let foodViewController = self.foodViewController {
            foodViewController.title = Strings.MenuItemFood
            viewControllers.append(foodViewController)
        }
        if let shopsViewController = self.shopsViewController {
            shopsViewController.title = Strings.MenuItemShops
            viewControllers.append(shopsViewController)
        }
        return viewControllers
    }

    private func setUpMenuPage(isDefault isDefault: Bool) {
        let parameters: [CAPSPageMenuOption] = parametersOfPageMenu(isDefault)
        self.pageMenu = CAPSPageMenu(viewControllers: self.itemViewControllers, frame: self.viewOfPageMenu.bounds, pageMenuOptions: parameters)
        if let pageMenu = self.pageMenu {
            self.viewOfPageMenu.addSubview(pageMenu.view)
        }
    }

    private func parametersOfPageMenu(isDefault: Bool) -> [CAPSPageMenuOption] {
        let menuItemWidth = isDefault ? kScreenSize.width / 3: kScreenSize.width / 3.5
        let menuHeight: CGFloat = 35
        let parameters: [CAPSPageMenuOption] = [.MenuHeight(menuHeight),
                .MenuItemWidth(menuItemWidth),
                .MenuMargin(0),
                .ScrollMenuBackgroundColor(Color.Gray235),
                .SelectionIndicatorColor(Color.Orange253),
                .SelectedMenuItemLabelColor(Color.Orange253)]
        return parameters
    }

    private func setUpNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updatePageMenuItem), name: kLGSideMenuControllerWillDismissLeftViewNotification, object: nil)
    }

    @objc private func updatePageMenuItem() {
        let newActiveMenuItems = BackgroundViewController.sharedInstance.activeMenuItems
        if !isChangeActiveMenuItems(newActiveMenuItems) {
            if let pageMenu = self.pageMenu {
                pageMenu.view.removeFromSuperview()
            }
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
        for element in self.activeMenuItems {
            switch element.item {
            case .Arts:
                if let artsViewController = self.artsViewController {
                    artsViewController.title = element.item.title
                    itemViewControllers.append(artsViewController)
                }
            case .Coffee:
                if let coffeeViewController = self.coffeeViewController {
                    coffeeViewController.title = element.item.title
                    itemViewControllers.append(coffeeViewController)
                }
            case .Drinks:
                if let drinksViewController = self.drinksViewController {
                    drinksViewController.title = element.item.title
                    itemViewControllers.append(drinksViewController)
                }
            case .Outdoors:
                if let outdoorsViewController = self.outdoorsViewController {
                    outdoorsViewController.title = element.item.title
                    itemViewControllers.append(outdoorsViewController)
                }
            case .Sights:
                if let sightsViewController = self.sightsViewController {
                    sightsViewController.title = element.item.title
                    itemViewControllers.append(sightsViewController)
                }
            case .Trending:
                if let trendingViewController = self.trendingViewController {
                    trendingViewController.title = element.item.title
                    itemViewControllers.append(trendingViewController)
                }
            }
        }
    }

    private func setUpNewActiveMenuItems() {
        if self.activeMenuItems.count == 0 {
            self.setUpMenuPage(isDefault: true)
            return
        }
        self.setUpMenuPage(isDefault: false)
    }

    private func isChangeActiveMenuItems(newActiveMenuItems: [ItemMenu]) -> Bool {
        let oldActiveMenuItems = self.activeMenuItems
        if oldActiveMenuItems.count != newActiveMenuItems.count {
            return false
        }
        for (index, element) in oldActiveMenuItems.enumerate() {
            if element.item != newActiveMenuItems[index].item {
                return false
            }
        }
        return true
    }
}
