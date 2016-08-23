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
    var shouldLoadMore: Bool {
        if willLoadMore {
            offset = offset + limit
        }
        return offset == venues.count
    }
    var isFavoriteMenu = false

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocationManager()
        self.setUpTableView()
        self.setUpRefreshControl()
        self.loadVenuesFromRealm()
        self.configureNotificationCenter()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let currentLocation = MyLocationManager.sharedInstanced.currentLocation
        if isViewFirstAppear && currentLocation != nil && self.venues.count == 0 {
            loadVenues()
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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

    private func configureNotificationCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadVenues), name: NotificationCenterKey.loadVenue, object: nil)
    }

    private func setUpRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), forControlEvents: .ValueChanged)
        self.venueTableView?.addSubview(refreshControl)
    }

    private func setupLocationManager() {
        if MyLocationManager.sharedInstanced.currentLocation == nil {
            MyLocationManager.sharedInstanced.startLocation()
            return
        }
    }

    func refreshData() {
        self.offset = 0
        self.willLoadMore = true
        self.deleteVenues()
        self.loadVenues()
    }

    func loadVenuesFromRealm() {
        do {
            let realm = try Realm()
            // print(Realm.Configuration.defaultConfiguration.fileURL)
            self.venues = realm.objects(Venue).filter("section = '\(self.section.rawValue)'")
        } catch {
            print("Realm Have Error!!")
        }
    }

    @objc private func loadVenues() {
        SVProgressHUD.show()
        self.refreshControl.endRefreshing()
        VenueService().loadVenues(section.rawValue, limit: self.limit, offset: self.offset) { (venues) in
            SVProgressHUD.dismiss()
            self.venueTableView?.reloadData()
            self.delegate?.menuItemDidLoadData(self.venues)
        }
    }

    private func deleteVenues() {
        RealmManager.sharedInstance.deleteSection(self.section.rawValue)
        self.venueTableView?.reloadData()
    }

    // MARK:- Public Functions

    func searchVenues(name: String, address: String) {
        self.deleteVenues()
        SVProgressHUD.show()
        VenueService().searchVeues(address, query: name, limit: self.limit, offset: self.offset) { (venues) in
            SVProgressHUD.dismiss()
            self.venueTableView?.reloadData()
        }
    }

    func loadMoreVenues() {
        VenueService().loadVenues(section.rawValue, limit: self.limit, offset: self.offset) { (venues) in
            self.venueTableView?.reloadData()
            self.willLoadMore = true
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
        detailVenueViewController.isFavoriteMenu = self.isFavoriteMenu
        let venue = self.venues[indexPath.row]
        detailVenueViewController.venue = venue
        UIApplication.sharedApplication().navigationController()?.pushViewController(detailVenueViewController, animated: true)
    }
}

//MARK:- Scroll View Delegate

extension MenuItemViewController {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if !willLoadMore {
            return
        }
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        if maximumOffset - currentOffset < 2 * self.rowHeight {
            if self.shouldLoadMore {
                willLoadMore = false
                self.loadMoreVenues()
            }
        }
    }
}
