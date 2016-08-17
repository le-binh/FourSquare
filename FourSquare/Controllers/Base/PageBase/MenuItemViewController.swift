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
import RealmSwift

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
    case Search = "search"
}

protocol MenuItemDelegate {
    func menuItemDidLoadData(venues: Results<Venue>)
}

class MenuItemViewController: BaseViewController {

    // MARK:- Properties
    var section: SectionQuery {
        return .Search
    }
    @IBOutlet weak var venueTableView: UITableView?
    let rowHeight: CGFloat = 140
    var venues: Results<Venue>!
    var delegate: MenuItemDelegate!
    var refreshControl: UIRefreshControl!
    let limit: Int = 10
    var offset: Int = 0
    var willLoadMore: Bool = true

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.setUpRefreshControl()
        self.loadVenuesFromRealm()
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

    private func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), forControlEvents: .ValueChanged)
        self.venueTableView?.addSubview(refreshControl)
    }

    func refreshData() {
        self.offset = 0
        self.deleteVenues()
        if self.section == .Search {
            self.refreshControl.endRefreshing()
        } else {
            self.loadVenues()
        }
    }

    func loadVenuesFromRealm() {
        do {
            let realm = try Realm()
//            print(Realm.Configuration.defaultConfiguration.fileURL)
            self.venues = realm.objects(Venue).filter("section = '\(self.section.rawValue)'")
        } catch {
            print("Realm Have Error!!")
        }
    }

    private func loadVenues() {
        SVProgressHUD.show()
        self.refreshControl.endRefreshing()
        VenueService().loadVenues(section.rawValue, limit: self.limit, offset: self.offset) { (venues) in
            SVProgressHUD.dismiss()
            self.venueTableView?.reloadData()
            if let delegate = self.delegate {
                delegate.menuItemDidLoadData(self.venues)
            }
        }
    }

    private func deleteVenues() {
        RealmManager.sharedInstance.deleteSection(self.section.rawValue)
        self.venueTableView?.reloadData()
    }

    private func loadMoreVenues() {
        VenueService().loadVenues(section.rawValue, limit: self.limit, offset: self.offset) { (venues) in
            self.venueTableView?.reloadData()
            self.willLoadMore = true
        }
    }

    // MARK:- Public Functions

    func searchVenues(name: String, address: String) {
        SVProgressHUD.show()
        VenueService().searchVeues(address, query: name, limit: self.limit, offset: self.offset) { (venues) in
            SVProgressHUD.dismiss()
            self.venueTableView?.reloadData()
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
        detailVenueViewController.venue = venue
        UIApplication.sharedApplication().navigationController()?.pushViewController(detailVenueViewController, animated: true)
    }
}

//MARK:- Scroll View Delegate

extension MenuItemViewController {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        if maximumOffset - currentOffset < 2 * self.rowHeight && willLoadMore {
            willLoadMore = false
            self.offset = self.offset + self.limit
            if self.section != .Search {
                self.loadMoreVenues()
            }
        }
    }
}
