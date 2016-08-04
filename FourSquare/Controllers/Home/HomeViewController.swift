//
//  HomeViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/1/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var listOrMapMenuButton: UIButton!

    @IBAction func showSideMenuAction(sender: AnyObject) {
        UIApplication.sharedApplication().backgroundViewController()?.showHideLeftViewAnimated(true, completionHandler: nil)
    }

    @IBAction func showListOrMapAction(sender: AnyObject) {
    }

}
