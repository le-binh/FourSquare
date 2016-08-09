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
    var searchBoxHeight: CGFloat = 0

    // MARK:- Life Cycle

    override func viewDidLoad() {
        self.title = Strings.SearchTitle
        super.viewDidLoad()
        self.configureUINavigationBar()
        self.containerView.backgroundColor = UIColor.grayColor()
        self.searchAgainButton.hidden = true
        self.searchBoxHeight = (self.searchBoxHeightLayoutConstraint.multiplier) * kScreenSize.height
    }

    // MARK:- Action

    @IBAction func showBoxSearch(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.searchBoxHeightLayoutConstraint.constant = 0
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
            self.searchAgainButton.hidden = false
        })
    }

    // MARK:- Private Functions
    private func configureUINavigationBar() {
        self.didShowMapView = false
        self.isSearchViewController = true
    }

}
