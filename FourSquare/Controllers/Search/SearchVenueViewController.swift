//
//  SearchVenueViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/9/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class SearchVenueViewController: BaseViewController {

    // MARK:- Properties

    @IBOutlet weak var searchAgainButton: UIButton!
    @IBOutlet weak var searchBoxView: UIView!
    @IBOutlet weak var nameVenueSearchTextField: UITextField!
    @IBOutlet weak var addressVenueSearchTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBoxHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchVenueButton: UIButton!
    var currentViewController: UIViewController!
    var searchBoxHeight: CGFloat = 0

    // MARK:- Life Cycle

    override func viewDidLoad() {
        self.title = Strings.SearchTitle
        super.viewDidLoad()
        self.setupUI()
        self.getDataFromUI()
        self.configureContainerView()
        self.configureNotificationCenter()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK:- Action

    @IBAction func showBoxSearch(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.searchBoxHeightLayoutConstraint.constant = 0
            self.searchVenueButton.hidden = false
            self.view.layoutIfNeeded()
            }, completion: { (complete) in
            self.searchAgainButton.hidden = true
        })
    }

    @IBAction func searchVenuesAction(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.searchBoxHeightLayoutConstraint.constant = -self.searchBoxHeight
            self.view.layoutIfNeeded()
            }, completion: { (complete) in
            self.searchVenueButton.hidden = true
            self.searchAgainButton.hidden = false
        })
    }

    // MARK:- Private Functions

    private func setupUI() {
        self.configureUINavigationBar()
        self.searchAgainButton.hidden = true
    }

    private func getDataFromUI() {
        self.searchBoxHeight = (self.searchBoxHeightLayoutConstraint.multiplier) * kScreenSize.height
    }

    private func configureUINavigationBar() {
        self.didShowMapView = false
        self.isSearchViewController = true
    }

    private func configureContainerView() {
        let tableViewSearchViewController = TableViewSearchViewController.vc()
        tableViewSearchViewController.view.frame = self.containerView.bounds
        self.addChildViewController(tableViewSearchViewController)
        self.containerView.addSubview(tableViewSearchViewController.view)
        self.currentViewController = tableViewSearchViewController
    }

    private func configureNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeTableViewToMapView), name: NotificationCenterKey.changeToMapViewSearch, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeMapViewToTableView), name: NotificationCenterKey.changeToTableViewSearch, object: nil)
    }

    @objc private func changeTableViewToMapView() {
        let mapSearchViewController = MapSearchViewController.vc()
        self.cycleViewController(currentViewController, toViewController: mapSearchViewController)
        self.currentViewController = mapSearchViewController
    }

    @objc private func changeMapViewToTableView() {
        let tableViewSearchViewController = TableViewSearchViewController.vc()
        self.cycleViewController(currentViewController, toViewController: tableViewSearchViewController)
        self.currentViewController = tableViewSearchViewController
    }

    private func cycleViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        newViewController.view.frame = self.containerView.bounds
        self.addChildViewController(newViewController)
        self.containerView.addSubview(newViewController.view)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.3, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        }) { (complete) in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            newViewController.didMoveToParentViewController(self)
        }
    }

}
