//
//  FavoriteViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

class FavoriteViewController: MenuItemViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar?.rightBarButtonHidden = true
        self.navigationBar?.title = Strings.FavoriteTitle
    }

    override func viewDidAppear(animated: Bool) {

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.venueTableView?.reloadData()
    }

    override func loadVenuesFromRealm() {
        self.venues = RealmManager.sharedInstance.getFavoriteVenues()
    }

    override func refreshData() {
        self.venueTableView?.reloadData()
        self.refreshControl.endRefreshing()
    }
}
