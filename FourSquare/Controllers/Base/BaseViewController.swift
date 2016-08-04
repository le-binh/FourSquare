//
//  BaseViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class BaseViewController: ViewController {

    // MARK:- Properties

    @IBOutlet weak var navigationBar: NavigationBar?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
    }

    // MARK:- Public Functions

    func configureNavigationBar() {
        self.setNavigationBarItem()
    }

    // MARK:- Private Function

    private func setNavigationBarItem() {

    }

}
