//
//  MenuItemViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/3/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class MenuItemViewController: UIViewController {

    @IBOutlet weak var venueTableView: UITableView!

    // MARK:- Properties

    var defaultItem: DefaultMenuItem?
    var menuItem: MenuItemsSlide?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let menuItem = self.menuItem {
            print(menuItem.title)
        }
        if let defaultItem = self.defaultItem {
            print(defaultItem.title)
        }
    }

}
