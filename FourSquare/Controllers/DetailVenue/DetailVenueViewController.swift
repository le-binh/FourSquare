//
//  DetailVenueViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

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
            return 5
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
    }
    override func favoriteAction(sender: AnyObject) {
        super.favoriteAction(sender)
        didAddFavorite = !didAddFavorite
    }

    // MARK:- Public Functions

    func loadVenueHours(id: String) {
        VenueService().loadVenueHours(id) { (hours) in
            self.venue?.hours = hours
            if self.venue?.hours != nil {
                self.detailVenueTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
            }
        }
    }

    func loadVenuePhotos(id: String) {
        VenueService().loadVenuePhotos(id) { (photos) in
            self.venue?.photos = photos
            self.detailVenueTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
    }

    // MARK:- Private Functions

    private func configureTableView() {
        self.detailVenueTableView.registerNib(ViewHeaderVenueDetail)
        self.detailVenueTableView.registerNib(DefaultVenueDetailCell)
        self.detailVenueTableView.registerNib(MapDetailVenueCell)
        self.detailVenueTableView.registerNib(TipsDetailVenueCell)
        self.detailVenueTableView.registerNib(PageImageHeaderView)
        self.detailVenueTableView.delegate = self
        self.detailVenueTableView.dataSource = self
        self.detailVenueTableView.rowHeight = UITableViewAutomaticDimension
        self.detailVenueTableView.estimatedRowHeight = 51
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
        return detailVenueSection.numberOfRow
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let detailVenueSection = DetailVenueSection(rawValue: indexPath.section) else {
            return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        guard let venue = self.venue else {
            return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        switch detailVenueSection {
        case .PageImage:
            return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        case .Information:
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
                cellMap.addressLabel.text = venue.location?.fullAddress
                cellMap.detailVenueViewController = self
                return cellMap
            case .Contact:
                cell.titleLabel.text = infomationSection.title
                let contact = venue.contact?.contact
                cell.textDetailLabel.text = contact == "" ? "Not Available" : contact
            case .Categories:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = venue.showCategories
            case .Hours:
                cell.titleLabel.text = infomationSection.title
                guard let hours = venue.hours else {
                    cell.textDetailLabel.text = "Not Available"
                    break
                }
                cell.textDetailLabel.text = hours.timeToday
            case .Rating:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = String(venue.rating)
            case .PriceTier:
                cell.titleLabel.text = infomationSection.title
                guard let tier = venue.price?.tier else {
                    cell.textDetailLabel.text = "0"
                    break
                }
                cell.textDetailLabel.text = String(tier)
            case .Verified:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = venue.verified ? "Yes" : "No"
            case .Website:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = venue.website == "" ? "Not Available" : venue.website
            }
            return cell
        case .Tips:
            let cell = tableView.dequeue(TipsDetailVenueCell)
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
            let view = tableView.dequeue(PageImageHeaderView)
            if let photos = self.venue?.photos {
                view.photos = photos
            }
            return view
        case .Information:
            view.titleHeader.text = Strings.DetailVenueTitleInformation
        case .Tips:
            view.titleHeader.text = Strings.DetailVenueTitleTips
        }
        return view
    }
}
