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
            return ""
        case .MenuItems:
            return "Menu Items"
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

    var height: CGFloat {
        switch self {
        case .MainMenu:
            return 0
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
            return "Home"
        case .Favorite:
            return "Favorite"
        case .History:
            return "History"
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
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(CustomMainMenuTableViewCell)
            return cell
        default:
            let cell = tableView.dequeue(CustomMenuItemsTableViewCell)
            return cell
        }
    }
}

extension LeftSideMenuViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        return 40
    }

}
