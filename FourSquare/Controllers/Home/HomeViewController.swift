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
import RealmSwift

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

enum AllMenuItem: String {
    case TopPicks = "Top Picks"
    case Food = "Food"
    case Shops = "Shops"
    case Drinks = "Drinks"
    case Coffee = "Coffee"
    case Arts = "Arts"
    case Outdoors = "Outdoors"
    case Sights = "Sights"
    case Trending = "Trending"
}

class HomeViewController: BaseViewController {

    // MARK:- Properties

    @IBOutlet weak var viewOfPageMenu: UIView!
    @IBOutlet weak var searchButton: UIButton!
    var pageMenu: CAPSPageMenu?
    var itemViewControllers: [MenuItemViewController] = []
    var activeMenuItems: [ItemMenu] = []
    var topPicksViewController: TopPicksViewController = TopPicksViewController.vc()
    var foodViewController: FoodViewController = FoodViewController.vc()
    var shopsViewController: ShopsViewController = ShopsViewController.vc()
    lazy var drinksViewController: DrinksViewController = DrinksViewController.vc()
    lazy var coffeeViewController: CoffeeViewController = CoffeeViewController.vc()
    lazy var artsViewController: ArtsViewController = ArtsViewController.vc()
    lazy var outdoorsViewController: OutdoorsViewController = OutdoorsViewController.vc()
    lazy var sightsViewController: SightsViewController = SightsViewController.vc()
    lazy var trendingViewController: TrendingViewController = TrendingViewController.vc()
    lazy var mapViewController: MapViewController = MapViewController.vc()

    var venues: Results<Venue>! {
        didSet {
            if didShowMapView {
                self.mapViewController.venues = self.venues
            }
        }
    }

    // MARK:- Life Cycle

    override func viewDidLoad() {
        self.title = Strings.HomeTitle
        super.viewDidLoad()
        self.configureMenuItemDelegate()
        self.itemViewControllers = self.setDefaultMenuItems()
        self.configureMenuPage()
        self.updatePageMenuItem()
        self.setUpNotificationCenter()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func showAndHideMapViewAction(sender: AnyObject) {
        super.showAndHideMapViewAction(sender)
        if didShowMapView {
            self.changeMapViewToTableView()
        } else {
            self.changeTableViewToMapView()
            self.mapViewController.venues = self.venues
        }
        didShowMapView = !didShowMapView
    }

    // MARK:- Action

    @IBAction func searchAction(sender: AnyObject) {
        let searchVenueViewController = SearchVenueViewController.vc()
        self.navigationController?.pushViewController(searchVenueViewController, animated: true)
    }

    // MARK:- Public Functions

    // MARK:- Private Function

    private func configureMenuItemDelegate() {
        self.topPicksViewController.delegate = self
        self.foodViewController.delegate = self
        self.shopsViewController.delegate = self
        self.drinksViewController.delegate = self
        self.coffeeViewController.delegate = self
        self.artsViewController.delegate = self
        self.outdoorsViewController.delegate = self
        self.sightsViewController.delegate = self
        self.trendingViewController.delegate = self
    }

    private func configureMenuPage() {
        self.setUpMenuPage(isDefault: true)
        self.pageMenu?.delegate = self
    }

    private func setDefaultMenuItems() -> [MenuItemViewController] {
        // self.initMenuItemViewController()
        var viewControllers: [MenuItemViewController] = []

        self.topPicksViewController.title = Strings.MenuItemTopPicks
        viewControllers.append(topPicksViewController)

        self.foodViewController.title = Strings.MenuItemFood
        viewControllers.append(foodViewController)

        self.shopsViewController.title = Strings.MenuItemShops
        viewControllers.append(shopsViewController)

        return viewControllers
    }

    private func setUpMenuPage(isDefault isDefault: Bool) {
        let parameters: [CAPSPageMenuOption] = parametersOfPageMenu(isDefault)
        self.pageMenu = CAPSPageMenu(viewControllers: self.itemViewControllers, frame: self.viewOfPageMenu.bounds, pageMenuOptions: parameters)
        if let pageMenu = self.pageMenu {
            self.addChildViewController(pageMenu)
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

    private func changeTableViewToMapView() {
        self.searchButton.hidden = true
        self.mapViewController = MapViewController.vc()
        let mapViewFrameX = self.viewOfPageMenu.frame.origin.x
        guard let menuHeight = self.pageMenu?.menuHeight else {
            return
        }
        let mapViewFrameY = self.viewOfPageMenu.frame.origin.x + menuHeight
        let mapViewFrameWidth = self.viewOfPageMenu.frame.width
        let mapViewFrameHeight = self.viewOfPageMenu.frame.height - menuHeight
        mapViewController.view.frame = CGRect(x: mapViewFrameX, y: mapViewFrameY, width: mapViewFrameWidth, height: mapViewFrameHeight)
        self.addChildViewController(mapViewController)
        self.viewOfPageMenu.addSubview(mapViewController.view)
    }

    private func changeMapViewToTableView() {
        self.searchButton.hidden = false
        self.mapViewController.view.removeFromSuperview()
        self.mapViewController.removeFromParentViewController()
    }

    @objc private func updatePageMenuItem() {
        let newActiveMenuItems = BackgroundViewController.sharedInstance.activeMenuItems
        if !isChangeActiveMenuItems(newActiveMenuItems) {
            if self.didShowMapView {
                self.changeMapViewToTableView()
                self.didShowMapView = false
            }
            self.pageMenu?.view.removeFromSuperview()
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
                artsViewController.title = element.item.title
                itemViewControllers.append(artsViewController)
            case .Coffee:
                coffeeViewController.title = element.item.title
                itemViewControllers.append(coffeeViewController)
            case .Drinks:
                drinksViewController.title = element.item.title
                itemViewControllers.append(drinksViewController)
            case .Outdoors:
                outdoorsViewController.title = element.item.title
                itemViewControllers.append(outdoorsViewController)
            case .Sights:
                sightsViewController.title = element.item.title
                itemViewControllers.append(sightsViewController)
            case .Trending:
                trendingViewController.title = element.item.title
                itemViewControllers.append(trendingViewController)
            }
        }
    }

    private func setUpNewActiveMenuItems() {
        if self.activeMenuItems.count == 0 {
            self.setUpMenuPage(isDefault: true)
        } else {
            self.setUpMenuPage(isDefault: false)
        }
        self.pageMenu?.delegate = self
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

extension HomeViewController: CAPSPageMenuDelegate {
    func didMoveToPage(controller: UIViewController, index: Int) {
        let itemViewController = self.itemViewControllers[index]
        if itemViewController.venues.count > 0 {
            self.venues = itemViewController.venues
        }
    }
}

extension HomeViewController: MenuItemDelegate {
    func menuItemDidLoadData(venues: Results<Venue>) {
        self.venues = venues
    }
}
