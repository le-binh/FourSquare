//
//  MenuItemViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/3/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils
import SVProgressHUD

enum SectionQuery: String {
    case TopPicks = "toppicks"
    case Arts = "arts"
    case Coffee = "coffee"
    case Drinks = "drinks"
    case Food = "food"
    case OutDoors = "outdoors"
    case Shops = "shops"
    case Sights = "sights"
    case Trending = "trending"
}

protocol MenuItemDelegate {
    func menuItemDidLoadData(venues: [Venue])
}

class MenuItemViewController: BaseViewController {

    // MARK:- Properties
    var section: SectionQuery {
        return .TopPicks
    }
    @IBOutlet weak var venueTableView: UITableView?
    let rowHeight: CGFloat = 140
    var venues: [Venue] = []
    var delegate: MenuItemDelegate!

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isViewFirstAppear {
            loadVenues()
        }
    }

    // MARK:- Private Function

    private func setUpTableView() {
        self.venueTableView?.backgroundColor = Color.Caramel255
        self.venueTableView?.separatorStyle = .None
        self.venueTableView?.registerNib(VenueItemTableViewCell)
        self.venueTableView?.dataSource = self
        self.venueTableView?.delegate = self
        self.venueTableView?.rowHeight = self.rowHeight
    }

    func loadVenues() {
        SVProgressHUD.show()
        VenueService().loadVenues(16.0592007, longtitude: 108.1769168, section: section.rawValue, limit: 10, offset: 0) { (venues) in
            SVProgressHUD.dismiss()
            self.venues = venues
            self.venueTableView?.reloadData()
            if let delegate = self.delegate {
                delegate.menuItemDidLoadData(self.venues)
            }
        }
    }
}

//MARK:- Table View Datasource

extension MenuItemViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(VenueItemTableViewCell)
        cell.setUpData(self.venues[indexPath.row])
        return cell
    }
}

//MARK:- Table View Delegate

extension MenuItemViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVenueViewController = DetailVenueViewController.vc()
        let venue = self.venues[indexPath.row]
        detailVenueViewController.title = venue.name
        detailVenueViewController.venue = venue
        UIApplication.sharedApplication().navigationController()?.pushViewController(detailVenueViewController, animated: true)
    }
}

//MARK:- Scroll View Delegate

extension MenuItemViewController {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {

    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

    }

}
