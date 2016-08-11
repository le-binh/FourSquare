//
//  TopPicksViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/5/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class TopPicksViewController: MenuItemViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTopPicks()
    }

    private func loadTopPicks() {
        Services.venueService.loadVenues(16.0592007, longtitude: 108.1769168, section: "toppicks", limit: 10, offset: 0) { (result) in
            // print(result.value)
        }
    }

}
