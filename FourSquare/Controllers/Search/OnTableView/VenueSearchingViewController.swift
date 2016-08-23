//
//  TableViewSearchViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/9/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class VenueSearchingViewController: MenuItemViewController {

    override func viewDidAppear(animated: Bool) {
        self.willLoadMore = false
    }

    override func loadMoreVenues() {

    }
    override func refreshData() {
        self.refreshControl.endRefreshing()
    }

}
