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

    @IBOutlet weak var researchButton: UIButton!
    @IBOutlet weak var searchBoxView: UIView!
    @IBOutlet weak var venueNameTextField: UITextField!
    @IBOutlet weak var venueAddressTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBoxHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    var currentViewController: UIViewController!
    var searchBoxHeight: CGFloat = 0

    // MARK:- Life Cycle

    override func viewDidLoad() {
        self.title = Strings.SearchTitle
        super.viewDidLoad()
        self.setupUI()
        self.getSearchBoxHeightFromUI()
        self.configureContainerView()
    }

    override func showAndHideMapViewAction(sender: AnyObject) {
        super.showAndHideMapViewAction(sender)
        if didShowMapView {
            self.changeMapViewToTableView()
        } else {
            self.changeTableViewToMapView()
        }
        self.showSearchBoxWithAnimation()
        didShowMapView = !didShowMapView
    }

    // MARK:- Action

    @IBAction func showSearchBox(sender: AnyObject) {
        self.setEmptyTextField()
        self.showSearchBoxWithAnimation()
    }

    @IBAction func searchVenuesAction(sender: AnyObject) {
        let venueName = self.venueNameTextField.text ?? ""
        let venueAddress = self.venueAddressTextField.text ?? ""
        if !venueName.isEmpty && !venueAddress.isEmpty {
            self.hiddenSearchBoxWithAnimation()
            if didShowMapView {
                let venueSearchingMapViewController = self.currentViewController as? VenueSearchingMapViewController
                venueSearchingMapViewController?.searchVenues(venueName, address: venueAddress)
            } else {
                let venueSearchingViewController = self.currentViewController as? VenueSearchingViewController
                venueSearchingViewController?.searchVenues(venueName, address: venueAddress)
            }
        }
    }

    // MARK:- Private Functions

    private func setupUI() {
        self.configureUINavigationBar()
        self.researchButton.hidden = true
    }

    private func getSearchBoxHeightFromUI() {
        self.searchBoxHeight = (self.searchBoxHeightLayoutConstraint.multiplier) * kScreenSize.height
    }

    private func configureUINavigationBar() {
        self.didShowMapView = false
    }

    private func configureContainerView() {
        let venueSearchingViewController = VenueSearchingViewController.vc()
        venueSearchingViewController.view.frame = self.containerView.bounds
        self.addChildViewController(venueSearchingViewController)
        self.containerView.addSubview(venueSearchingViewController.view)
        self.currentViewController = venueSearchingViewController
    }

    private func changeTableViewToMapView() {
        let venueSearchingMapViewController = VenueSearchingMapViewController.vc()
        self.cycleViewController(currentViewController, toViewController: venueSearchingMapViewController)
        self.currentViewController = venueSearchingMapViewController
    }

    private func changeMapViewToTableView() {
        let venueSearchingViewController = VenueSearchingViewController.vc()
        self.cycleViewController(currentViewController, toViewController: venueSearchingViewController)
        self.currentViewController = venueSearchingViewController
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

    private func hiddenSearchBoxWithAnimation() {
        UIView.animateWithDuration(0.3, animations: {
            self.searchBoxHeightLayoutConstraint.constant = -self.searchBoxHeight
            self.view.layoutIfNeeded()
            }, completion: { (complete) in
            self.searchButton.hidden = true
            self.researchButton.hidden = false
        })
    }

    private func showSearchBoxWithAnimation() {
        UIView.animateWithDuration(0.3, animations: {
            self.searchBoxHeightLayoutConstraint.constant = 0
            self.searchButton.hidden = false
            self.view.layoutIfNeeded()
            }, completion: { (complete) in
            self.researchButton.hidden = true
        })
    }

    private func setEmptyTextField() {
        self.venueNameTextField.text = ""
        self.venueAddressTextField.text = ""
    }

}
