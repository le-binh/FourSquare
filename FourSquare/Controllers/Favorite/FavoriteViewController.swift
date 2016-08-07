//
//  FavoriteViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class FavoriteViewController: MenuItemViewController {

    override func viewDidLoad() {
        self.title = Strings.FavoriteTitle
        super.viewDidLoad()
        self.navigationBar?.rightBarButtonHidden = true
    }

}
