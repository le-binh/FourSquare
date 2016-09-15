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

protocol MenuItemDelegate: NSObjectProtocol {
    func menuItemDidLoadData(venues: Results<Venue>)
}

class MenuItemViewController: BaseViewController {

    // MARK:- Properties
    var section: SectionQuery {
        return .Search
    }
    @IBOutlet private(set) weak var venueTableView: UITableView?
    let rowHeight: CGFloat = 140
    let loadMoreIndicatorHeight: CGFloat = 40
    var venues: Results<Venue>!
    weak var delegate: MenuItemDelegate!
    var refreshControl: UIRefreshControl!
    let limit: Int = 10
    var offset: Int = 0
    var willLoadMore: Bool = true
    var isRefresh: Bool = false {
        didSet {
            if isRefresh {
                self.clearLoadMoreIndicator()
            }
        }
    }
    var shouldLoadMore: Bool {
        if self.isRefresh {
            self.offset = 0
        }
        if self.willLoadMore && offset < venues.count {
            offset = offset + limit
            return offset == venues.count
        }
        return false
    }

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
        if isViewFirstAppear && currentLocation != nil && self.venues.isEmpty {
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

    private func addLoadMoreIndicator() {
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: self.loadMoreIndicatorHeight)
        self.venueTableView?.tableFooterView = spinner
    }

    private func clearLoadMoreIndicator() {
        let footerView = self.venueTableView?.tableFooterView as? UIActivityIndicatorView
        footerView?.stopAnimating()
        self.venueTableView?.tableFooterView = nil
        self.venueTableView?.reloadData()
    }

    private func setupLocationManager() {
        if MyLocationManager.sharedInstanced.currentLocation == nil {
            MyLocationManager.sharedInstanced.startLocation()
            return
        }
    }

    func refreshData() {
        self.offset = 0
        self.isRefresh = true
        self.willLoadMore = true
        self.clearVenues()
        self.loadVenues()
    }

    func loadVenuesFromRealm() {
        self.venues = RealmManager.sharedInstance.getVenuesBySection(self.section)
    }

    @objc private func loadVenues() {
        if !isRefresh && willLoadMore {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.Clear)
        }
        VenueService().loadVenues(section.rawValue, limit: self.limit, offset: self.offset) { (error) in
            SVProgressHUD.dismiss()
            self.isRefresh = false
            self.venueTableView?.reloadData()
            self.refreshControl.endRefreshing()
            self.delegate?.menuItemDidLoadData(self.venues)
        }
    }

    private func clearVenues() {
        RealmManager.sharedInstance.clearSection(self.section.rawValue)
        self.venueTableView?.reloadData()
    }

    // MARK:- Public Functions

    func searchVenues(name: String, address: String) {
        self.clearVenues()
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.Clear)
        VenueService().searchVeues(address, query: name) { (error) in
            SVProgressHUD.dismiss()
            self.venueTableView?.reloadData()
        }
    }

    func loadMoreVenues() {
        VenueService().loadVenues(section.rawValue, limit: self.limit, offset: self.offset) { (error) in
            self.venueTableView?.reloadData()
            self.willLoadMore = true
            UIView.animateWithDuration(0.2, animations: {
                self.clearLoadMoreIndicator()
            })
        }
    }

}

// MARK:- Table View Datasource

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

// MARK:- Table View Delegate

extension MenuItemViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVenueViewController = DetailVenueViewController.vc()
        let venue = self.venues[indexPath.row]
        detailVenueViewController.venue = venue
        UIApplication.sharedApplication().navigationController()?.pushViewController(detailVenueViewController, animated: true)
    }
}

// MARK:- Scroll View Delegate

extension MenuItemViewController {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if !willLoadMore {
            return
        }
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        if maximumOffset - currentOffset < 3 * self.rowHeight && !isRefresh {
            if self.shouldLoadMore {
                if let contentOffset = self.venueTableView?.contentOffset {
                    let newContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + 50)
                    if self.venueTableView?.tableFooterView == nil && maximumOffset - currentOffset == 0 {
                        self.venueTableView?.setContentOffset(newContentOffset, animated: true)
                    }
                }
                self.addLoadMoreIndicator()
                willLoadMore = false
                self.isRefresh = false
                self.loadMoreVenues()
                return
            }
            UIView.animateWithDuration(0.2, animations: {
                self.clearLoadMoreIndicator()
            })
        }
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
}
