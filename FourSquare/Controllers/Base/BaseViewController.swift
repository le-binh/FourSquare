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

    // MARK:- Property

    @IBOutlet weak var navigationBar: NavigationBar?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }

    // MARK: Public Functions

    func backAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    func menuAction(sender: AnyObject) {
        UIApplication.sharedApplication().backgroundViewController()?.showHideLeftViewAnimated(true, completionHandler: nil)
    }

    func mapAction(sender: AnyObject) {

    }

    func setupNavigationBar() {
        setNavigationBarItem()
    }

    func setNavigationBarItem() {
        navigationBar?.title = self.title
        if let rootNavigation = navigationController?.viewControllers.first {
            if rootNavigation == self {
                addMenuLeftBarButton()
            } else {
                addBackLeftBarButton()
            }
        }
    }

    // MARK:- Private functions

    private func addMenuLeftBarButton() {
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "side_menu_ic"), forState: .Normal)
        menuButton.addTarget(self, action: #selector(self.menuAction), forControlEvents: .TouchUpInside)
        navigationBar?.leftBarButton = menuButton
    }

    private func addBackLeftBarButton() {

    }

    private func addMapRightBarButton() {
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "list_map_ic"), forState: .Normal)
        menuButton.addTarget(self, action: #selector(self.mapAction), forControlEvents: .TouchUpInside)
        navigationBar?.rightBarButton = menuButton
    }

    private func addPageRightBarButton() {

    }

}
