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

    @IBOutlet weak var showOrHideSearchBoxButton: UIButton!
    @IBOutlet weak var searchBoxView: UIView!
    @IBOutlet weak var venueNameTextField: UITextField!
    @IBOutlet weak var venueAddressTextField: UITextField!
    @IBOutlet weak var searchBoxTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBoxHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    private let collapseArrowImage = UIImage(named: "collapse_arrow")
    private let expandArrowImage = UIImage(named: "expand_arrow")
    var currentViewController: UIViewController!
    var searchBoxHeight: CGFloat = 0
    var isShowSearchBox: Bool = true {
        didSet {
            self.setIconShowOrHideArrowButton()
        }
    }

    // MARK:- Life Cycle

    override func viewDidLoad() {
        self.title = Strings.SearchTitle
        super.viewDidLoad()
        self.setupUI()
        self.cleanDatabase()
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
        didShowMapView = !didShowMapView
    }

    // MARK:- Action

    @IBAction func showOrHideSearchBox(sender: AnyObject) {
        if isShowSearchBox {
            self.hiddenSearchBoxWithAnimation()
        } else {
            self.resetSearchBoxTitle()
            self.showSearchBoxWithAnimation()
        }
    }

    @IBAction func searchVenuesAction(sender: AnyObject) {
        let venueName = self.venueNameTextField.text ?? ""
        let venueAddress = self.venueAddressTextField.text ?? ""
        if !venueName.isEmpty && !venueAddress.isEmpty {
            self.venueNameTextField.endEditing(true)
            self.venueAddressTextField.endEditing(true)
            self.changeSearchBoxTitle(venueName, address: venueAddress)
            self.hiddenSearchBoxWithAnimation()
            if didShowMapView {
                let venueSearchingMapViewController = self.currentViewController as? VenueSearchingMapViewController
                venueSearchingMapViewController?.searchVenues(venueName, address: venueAddress)
            } else {
                let venueSearchingViewController = self.currentViewController as? VenueSearchingViewController
                venueSearchingViewController?.searchVenues(venueName, address: venueAddress)
            }
        } else {
            self.errorMessageComment(Strings.ErrorTitle, message: Strings.EmptySearchError)
        }
    }

    // MARK:- Private Functions

    private func setupUI() {
        self.configureUINavigationBar()
    }

    private func getSearchBoxHeightFromUI() {
        self.searchBoxHeight = (self.searchBoxHeightLayoutConstraint.multiplier) * kScreenSize.height
    }

    private func configureUINavigationBar() {
        self.didShowMapView = false
    }

    private func errorMessageComment(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Strings.OKString, style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
        self.searchBoxHeightLayoutConstraint.constant = -self.searchBoxHeight
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (complete) in
            if complete {
                self.searchButton.hidden = true
                self.isShowSearchBox = false
            }
        })
    }

    private func showSearchBoxWithAnimation() {
        self.searchBoxHeightLayoutConstraint.constant = 0
        UIView.animateWithDuration(0.3, animations: {
            self.searchButton.hidden = false
            self.view.layoutIfNeeded()
            }, completion: { (complete) in
            self.isShowSearchBox = true
        })
    }

    private func changeSearchBoxTitle(name: String, address: String) {
        self.searchBoxTitleLabel.text = "\(name) - \(address)"
    }

    private func resetSearchBoxTitle() {
        self.searchBoxTitleLabel.text = Strings.WhatAreYouLookingFor
    }

    private func setIconShowOrHideArrowButton() {
        self.showOrHideSearchBoxButton.setImage(isShowSearchBox ? collapseArrowImage : expandArrowImage, forState: .Normal)
    }

    private func cleanDatabase() {
        RealmManager.sharedInstance.deleteVenuesWithSectionSearch()
    }

}
