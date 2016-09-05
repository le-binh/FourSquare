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
        self.configureNavigationBar()
        self.disableLoadMoreAndRefresh()
    }

    override func viewDidAppear(animated: Bool) {
    }

    override func loadVenuesFromRealm() {
        self.venues = RealmManager.sharedInstance.getHistoryVenues()
    }

    override func refreshData() {
    }

    private func configureNavigationBar() {
        self.navigationBar?.rightBarButtonHidden = true
        self.navigationBar?.title = Strings.HistoryTitle
    }

    private func disableLoadMoreAndRefresh() {
        self.willLoadMore = false
        self.refreshControl.removeFromSuperview()
    }

}
