//
//  LeftSideMenuViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/1/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

enum SlideMenuSection: Int {

    case MainMenu
    case MenuItems

    var title: String {
        switch self {
        case .MainMenu:
            return Strings.MainMenuSectionTitle
        case .MenuItems:
            return Strings.MenuItemsSectionTitle
        }
    }

    var numberOfRow: Int {
        switch self {
        case .MainMenu:
            return 3
        case .MenuItems:
            return 6
        }
    }

    var rowHeight: CGFloat {
        switch self {
        case .MainMenu:
            return 60
        case .MenuItems:
            return 40
        }
    }

    var sectionHeight: CGFloat {
        switch self {
        case .MainMenu:
            return 0.000001
        case .MenuItems:
            return 45
        }
    }
}

enum MainMenuSlide: Int {
    case Home
    case Favorite
    case History

    var title: String {
        switch self {
        case .Home:
            return Strings.MainMenuHomeTitle
        case .Favorite:
            return Strings.MainMenuFavoriteTitle
        case .History:
            return Strings.MainMenuHistoryTitle
        }
    }

    var icon: UIImage {
        switch self {
        case .Home:
            return UIImage(named: "menu_home_ic")!
        case .Favorite:
            return UIImage(named: "menu_favorite_ic")!
        case .History:
            return UIImage(named: "menu_history_ic")!
        }
    }

}

enum MenuItemsSlide: Int {

    case Drinks
    case Coffee
    case Arts
    case Outdoors
    case Sights
    case Trending

    var title: String {
        switch self {
        case .Drinks:
            return Strings.MenuItemsDrinksTitle
        case .Coffee:
            return Strings.MenuItemsCoffeeTitle
        case .Arts:
            return Strings.MenuItemsArtsTitle
        case .Outdoors:
            return Strings.MenuItemsOutdoorsTitle
        case .Sights:
            return Strings.MenuItemsSightsTitle
        case .Trending:
            return Strings.MenuItemsTrendingTitle
        }
    }
}

class LeftSideMenuViewController: UIViewController {

    // MARK:- Properties

    @IBOutlet weak var menuTableView: UITableView!

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMenuTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Private

    private func setUpMenuTableView() {
        self.menuTableView.registerNib(CustomMainMenuTableViewCell)
        self.menuTableView.registerNib(CustomMenuItemsTableViewCell)
        self.menuTableView.registerNib(ViewForHeaderMenuItems)
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
    }

}

extension LeftSideMenuViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let slideMenuSection = SlideMenuSection(rawValue: section) else {
            return 0
        }
        return slideMenuSection.numberOfRow
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let slideMenuSection = SlideMenuSection(rawValue: indexPath.section)

        switch slideMenuSection! {
        case .MainMenu:
            let cell = tableView.dequeue(CustomMainMenuTableViewCell)

            let mainMenuSlide = MainMenuSlide(rawValue: indexPath.row)

            cell.configureCell(mainMenuSlide!.title, icon: mainMenuSlide!.icon)

            return cell

        case .MenuItems:
            let cell = tableView.dequeue(CustomMenuItemsTableViewCell)

            let menuItemsSlide = MenuItemsSlide(rawValue: indexPath.row)

            cell.configureCell(menuItemsSlide!)

            cell.selectionStyle = .None

            return cell
        }
    }
}

extension LeftSideMenuViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        guard let slideMenuSection = SlideMenuSection(rawValue: indexPath.section) else {
            return 0
        }
        return slideMenuSection.rowHeight
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let slideMenuSection = SlideMenuSection(rawValue: section) else {
            return 0
        }
        return slideMenuSection.sectionHeight
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let slideMenuSection = SlideMenuSection(rawValue: section) else {
            return nil
        }
        switch slideMenuSection {
        case .MainMenu:
            return nil
        default:
            let view = tableView.dequeue(ViewForHeaderMenuItems)
            return view
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let slideMenuSection = SlideMenuSection(rawValue: indexPath.section) else {
            return
        }
        switch slideMenuSection {
        case .MainMenu:
            guard let mainMenuSlide = MainMenuSlide(rawValue: indexPath.row) else {
                return
            }
            switch mainMenuSlide {
            case .Home:
                SlideMenu.getRootViewController.popToRootViewControllerAnimated(false)
                SlideMenu.getRootBackground.hideLeftViewAnimated(true, completionHandler: nil)
            case .Favorite:
                let favoriteViewController = FavoriteViewController.vc()
                SlideMenu.getRootViewController.pushViewController(favoriteViewController, animated: false)
                SlideMenu.getRootBackground.hideLeftViewAnimated(true, completionHandler: nil)
            case .History:
                let historyViewController = HistoryViewController.vc()
                SlideMenu.getRootViewController.pushViewController(historyViewController, animated: false)
                SlideMenu.getRootBackground.hideLeftViewAnimated(true, completionHandler: nil)
            }
        default:
            return
        }
    }
}
