//
//  LeftSideMenuViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/1/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils
import LGSideMenuController
import RealmSwift

enum SlideMenuSection: Int {
    case Login
    case MainMenu
    case MenuItems

    var title: String {
        switch self {
        case .Login:
            return Strings.Login
        case .MainMenu:
            return Strings.MainMenuSectionTitle
        case .MenuItems:
            return Strings.MenuItemsSectionTitle
        }
    }

    var numberOfRow: Int {
        switch self {
        case .Login:
            let user = UserRealmManager.sharedInstance.getUser()
            return user != nil ? 1 : 0
        case .MainMenu:
            return 3
        case .MenuItems:
            return 6
        }
    }

    var rowHeight: CGFloat {
        switch self {
        case .Login:
            return 99 * kScreenSize.width / 375
        case .MainMenu:
            return 60 * kScreenSize.width / 375
        case .MenuItems:
            return 35 * kScreenSize.width / 375
        }
    }

    var sectionHeight: CGFloat {
        switch self {
        case .Login:
            return .min
        case .MainMenu:
            return .min
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
    var homeViewController: HomeViewController?
    private var favoriteViewController: FavoriteViewController?
    private var historyViewController: HistoryViewController?
    private var currentMainMenuSide: MainMenuSlide = .Home

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
        self.menuTableView.registerNib(LogoutTableViewCell)
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
    }

    private func changeRootViewController(viewController: UIViewController) {
        let navi = UINavigationController(rootViewController: viewController)
        navi.navigationBar.hidden = true
        UIApplication.sharedApplication().backgroundViewController()?.rootViewController = navi
    }

    private func logoutUserAction() {
        UserRealmManager.sharedInstance.deleteUser()
        let indexSet = NSIndexSet(indexesInRange: NSRange(location: 0, length: 1))
        self.menuTableView.reloadSections(indexSet, withRowAnimation: .Fade)
    }
}

extension LeftSideMenuViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let slideMenuSection = SlideMenuSection(rawValue: section) else {
            return 0
        }
        return slideMenuSection.numberOfRow
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let slideMenuSection = SlideMenuSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch slideMenuSection {
        case .Login:
            let cell = tableView.dequeue(LogoutTableViewCell)
            cell.delegate = self
            return cell
        case .MainMenu:
            let cell = tableView.dequeue(CustomMainMenuTableViewCell)

            guard let mainMenuSlide = MainMenuSlide(rawValue: indexPath.row) else {
                return cell
            }

            cell.configureCell(mainMenuSlide.title, icon: mainMenuSlide.icon)

            return cell

        case .MenuItems:
            let cell = tableView.dequeue(CustomMenuItemsTableViewCell)
            guard let menuItemsSlide = MenuItemsSlide(rawValue: indexPath.row) else {
                return cell
            }
            cell.configureCell(menuItemsSlide)
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
        return .min
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let slideMenuSection = SlideMenuSection(rawValue: section) else {
            return nil
        }
        switch slideMenuSection {
        case .MenuItems:
            let view = tableView.dequeue(ViewForHeaderMenuItems)
            view.titleMenu.text = Strings.MenuItemsSectionTitle
            return view
        default:
            return nil
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
            if currentMainMenuSide == mainMenuSlide {
                UIApplication.sharedApplication().backgroundViewController()?.hideLeftViewAnimated(true, completionHandler: nil)
            }
            switch mainMenuSlide {
            case .Home:
                if let homeViewController = self.homeViewController {
                    self.changeRootViewController(homeViewController)
                }
            case .Favorite:
                self.favoriteViewController = FavoriteViewController.vc()
                if let favoriteViewController = self.favoriteViewController {
                    self.changeRootViewController(favoriteViewController)
                }
            case .History:
                self.historyViewController = HistoryViewController.vc()
                if let historyViewController = self.historyViewController {
                    self.changeRootViewController(historyViewController)
                }
            }
            self.currentMainMenuSide = mainMenuSlide
            UIApplication.sharedApplication().backgroundViewController()?.hideLeftViewAnimated(true, completionHandler: nil)
        default:
            LoginService().login()
        }
    }
}

extension LeftSideMenuViewController: LogoutCellDelegate {
    func logoutAction() {
        self.logoutUserAction()
    }
}
