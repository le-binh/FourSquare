//
//  FavoriteViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/2/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBAction func showSideMenuAction(sender: AnyObject) {
        UIApplication.sharedApplication().backgroundViewController()?.showHideLeftViewAnimated(true, completionHandler: nil)
    }

}
