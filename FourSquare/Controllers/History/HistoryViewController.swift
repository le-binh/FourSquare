//
//  HistoryViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class HistoryViewController: MenuItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar?.rightBarButtonHidden = true
        self.navigationBar?.title = Strings.HistoryTitle
    }

    override func viewDidAppear(animated: Bool) {

    }
}
