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

    case MainMenu
    case MenuItems
    case Login

    var title: String {
        switch self {
        case .MainMenu:
            return Strings.MainMenuSectionTitle
        case .MenuItems:
            return Strings.MenuItemsSectionTitle
        case .Login:
            let user = UserRealmManager.sharedInstance.getUser()
            return user != nil ? Strings.Logout : Strings.Login
        }
    }

    var numberOfRow: Int {
        switch self {
        case .MainMenu:
            return 3
        case .MenuItems:
            return 6
        case .Login:
            let user = UserRealmManager.sharedInstance.getUser()
            return user != nil ? 1 : 0
        }
    }

    var rowHeight: CGFloat {
        switch self {
        case .MainMenu:
            return 60
        case .MenuItems:
            return 35
        case .Login:
            return 80
        }
    }

    var sectionHeight: CGFloat {
        switch self {
        case .MainMenu:
            return 0.000001
        case .MenuItems:
            return 45
        case .Login:
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
        self.menuTableView.registerNib(LoginAndLogoutFooterView)
        self.menuTableView.registerNib(LoginTableViewCell)
        if isPhone4 {
            self.menuTableView.scrollEnabled = true
        }
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
    }

    private func changeRootViewController(viewController: UIViewController) {
        let navi = UINavigationController(rootViewController: viewController)
        navi.navigationBar.hidden = true
        UIApplication.sharedApplication().backgroundViewController()?.rootViewController = navi
    }

    private func conectToFourSquare() {
        LoginService().login()
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
        case .Login:
            let cell = tableView.dequeue(LoginTableViewCell)
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
        case .MenuItems:
            let view = tableView.dequeue(ViewForHeaderMenuItems)
            view.titleMenu.text = Strings.MenuItemsSectionTitle
            return view
        case .Login:
            let view = tableView.dequeue(LoginAndLogoutFooterView)
            view.footerTitleLabel.text = slideMenuSection.title
            view.delegate = self
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
            if currentMainMenuSide == mainMenuSlide {
                UIApplication.sharedApplication().backgroundViewController()?.hideLeftViewAnimated(true, completionHandler: nil)
                break
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
            return
        }
    }
}

extension LeftSideMenuViewController: LoginAndLogoutDelegate {
    func loginOrLogoutAction(title: String) {
        if title == Strings.Login {
            self.conectToFourSquare()
        } else {
            UserRealmManager.sharedInstance.deleteUser()
            self.menuTableView.reloadData()
        }
    }
}
