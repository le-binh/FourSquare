//
//  DetailVenueViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils
import SVProgressHUD

enum DetailVenueSection: Int {
    case PageImage
    case Information
    case Tips
    var title: String {
        switch self {
        case .PageImage:
            return ""
        case .Information:
            return Strings.DetailVenueTitleInformation
        case .Tips:
            return Strings.DetailVenueTitleTips
        }
    }
    var numberOfRow: Int {
        switch self {
        case .PageImage:
            return 0
        case .Information:
            return 9
        case .Tips:
            return 0
        }
    }
    var sectionHeight: CGFloat {
        switch self {
        case .PageImage:
            return (2 / 3) * kScreenSize.width
        default:
            return 30
        }
    }
}

enum InfomationSection: Int {
    case Name
    case Address
    case Contact
    case Categories
    case Hours
    case Rating
    case PriceTier
    case Verified
    case Website

    var title: String {
        switch self {
        case .Name:
            return Strings.InfomationTitleName
        case .Address:
            return Strings.InfomationTitleAddress
        case .Contact:
            return Strings.InfomationTitleContact
        case .Categories:
            return Strings.InfomationTitleCategories
        case .Hours:
            return Strings.InfomationTitleHours
        case .Rating:
            return Strings.InfomationTitleRating
        case .PriceTier:
            return Strings.InfomationTitlePriceTier
        case .Verified:
            return Strings.InfomationTitleVerified
        case .Website:
            return Strings.InfomationTitleWebsite
        }
    }
}

class DetailVenueViewController: BaseViewController {

    // MARK:- Properties

    @IBOutlet weak var detailVenueTableView: UITableView!
    var venue: Venue?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.navigationBar?.title = venue?.name
        self.clearPhotos()
        self.addHistory()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isViewFirstAppear {
            self.loadVenueDetail()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.configureFavoriteButton()
    }

    override func favoriteAction(sender: AnyObject) {
        super.favoriteAction(sender)
        guard let venue = self.venue else { return }
        if didAddFavorite {
            RealmManager.sharedInstance.deleteFavorite(venue.id)
        } else {
            RealmManager.sharedInstance.addFavorite(venue)
        }
        didAddFavorite = !didAddFavorite
    }

    // MARK:- Private Functions

    private func configureTableView() {
        self.detailVenueTableView.registerNib(ViewHeaderVenueDetail)
        self.detailVenueTableView.registerNib(DefaultVenueDetailCell)
        self.detailVenueTableView.registerNib(MapDetailVenueCell)
        self.detailVenueTableView.registerNib(TipsDetailVenueCell)
//        self.detailVenueTableView.registerNib(PageImageHeaderView)
        self.detailVenueTableView.registerNib(ImagesCollectionViewHeader)
        self.detailVenueTableView.delegate = self
        self.detailVenueTableView.dataSource = self
        self.detailVenueTableView.rowHeight = UITableViewAutomaticDimension
        self.detailVenueTableView.estimatedRowHeight = 51
    }

    private func configureFavoriteButton() {
        if let venue = self.venue {
            self.didAddFavorite = venue.didFavorite
        }
    }

    private func addHistory() {
        if let venue = self.venue {
            RealmManager.sharedInstance.addHistory(venue)
        }
    }

    private func loadVenueDetail() {
        if self.venue?.photos.count > 0 && self.venue?.tips.count > 0 {
            return
        }
        SVProgressHUD.show()
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        self.loadVenueHours {
            dispatch_group_leave(group)
        }
        dispatch_group_enter(group)
        self.loadVenuePhotos {
            dispatch_group_leave(group)
        }
        dispatch_group_enter(group)
        self.loadVenueTips {
            dispatch_group_leave(group)
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
            self.detailVenueTableView.reloadData()
        }
    }

    private func loadVenueHours(completion: () -> Void) {
        guard let venue = self.venue else {
            completion()
            return
        }
        VenueService().loadVenueHours(venue.id, section: venue.section) { (hours) in
            completion()
        }
    }

    private func loadVenuePhotos(completion: () -> Void) {
        guard let venue = self.venue else {
            completion()
            return
        }
        VenueService().loadVenuePhotos(venue.id, section: venue.section) { (photos) in
            completion()
        }
    }

    private func loadVenueTips(completion: () -> Void) {
        guard let venue = self.venue else {
            completion()
            return
        }
        VenueService().loadVenueTips(venue.id, section: venue.section) { (tips) in
            completion()
        }
    }

    private func informationCell(venue: Venue, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let infomationSection = InfomationSection(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeue(DefaultVenueDetailCell)
        cell.titleLabel.text = infomationSection.title
        switch infomationSection {
        case .Name:
            cell.textDetailLabel.text = venue.name
        case .Address:
            let cellMap = tableView.dequeue(MapDetailVenueCell)
            cellMap.venue = venue
            cellMap.detailVenueViewController = self
            return cellMap
        case .Contact:
            guard let contact = venue.contact?.contact else { break }
            cell.textDetailLabel.text = contact.isEmpty ? Strings.NotAvailable : contact
        case .Categories:
            cell.textDetailLabel.text = venue.showCategories
        case .Hours:
            cell.textDetailLabel.text = venue.hours?.timeToday ?? Strings.NotAvailable
        case .Rating:
            cell.textDetailLabel.text = "\(venue.rating)"
        case .PriceTier:
            cell.textDetailLabel.text = "\(venue.price?.tier ?? 0)"
        case .Verified:
            cell.textDetailLabel.text = venue.verified ? Strings.Verified : Strings.NotVerified
        case .Website:
            cell.textDetailLabel.text = venue.website.isEmpty ? Strings.NotAvailable : venue.website
        }
        return cell
    }

    private func clearPhotos() {
    }
}

//MARK:- Table View Datasource

extension DetailVenueViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailVenueSection = DetailVenueSection(rawValue: section) else {
            return 0
        }
        switch detailVenueSection {
        case .Tips:
            guard let venue = self.venue else {
                return detailVenueSection.numberOfRow
            }
            return venue.tips.count
        default:
            return detailVenueSection.numberOfRow
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let detailVenueSection = DetailVenueSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        guard let venue = self.venue else {
            return UITableViewCell()
        }
        switch detailVenueSection {
        case .PageImage:
            return UITableViewCell()
        case .Information:
            return informationCell(venue, tableView: tableView, indexPath: indexPath)
        case .Tips:
            let cell = tableView.dequeue(TipsDetailVenueCell)
            if !venue.tips.isEmpty {
                cell.setUpData(venue.tips[indexPath.row])
            }
            return cell
        }
    }
}

//MARK:- Table View Delegate

extension DetailVenueViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let detailVenueSection = DetailVenueSection(rawValue: section) else {
            return 0
        }
        return detailVenueSection.sectionHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let detailVenueSection = DetailVenueSection(rawValue: section) else {
            return nil
        }
        let view = tableView.dequeue(ViewHeaderVenueDetail)
        switch detailVenueSection {
        case .PageImage:
//            let view = tableView.dequeue(PageImageHeaderView)
//            guard let venue = self.venue else {
//                return view
//            }
//            view.photos = venue.photos
//            return view
            let view = tableView.dequeue(ImagesCollectionViewHeader)
            guard let venue = self.venue else {
                return view
            }
            view.photos = venue.photos
            return view
        case .Information:
            view.titleHeader.text = Strings.DetailVenueTitleInformation
        case .Tips:
            view.titleHeader.text = Strings.DetailVenueTitleTips
        }
        return view
    }
}
