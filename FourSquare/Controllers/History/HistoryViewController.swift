//
//  HistoryViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

class HistoryViewController: MenuItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar?.rightBarButtonHidden = true
        self.navigationBar?.title = Strings.HistoryTitle
    }

    override func viewDidAppear(animated: Bool) {

    }

    override func loadVenuesFromRealm() {
        do {
            let realm = try Realm()
            self.venues = realm.objects(Venue).filter("isHistory = true").sorted("historyTimestamp", ascending: false)
        } catch {
            print("Realm Have Error!!")
        }
    }

    override func refreshData() {
        self.venueTableView?.reloadData()
        self.refreshControl.endRefreshing()
    }

}
