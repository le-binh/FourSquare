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

    var isMenuLeftBarButton: Bool? {
        didSet {
            guard let isMenuButton = self.isMenuLeftBarButton else {
                return
            }
            if isMenuButton {
                self.addMenuLeftBarButton()
            } else {
                self.addBackLeftBarButton()
            }
        }
    }

    var isMapRightBarButton: Bool? {
        didSet {
            guard let isMapButton = self.isMapRightBarButton else {
                return
            }
            if isMapButton {
                self.addMapRightBarButton()
            } else {
                self.addPageRightBarButton()
            }
        }
    }

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
