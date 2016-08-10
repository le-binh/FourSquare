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

    let imageNames = ["detail_venue_image", "thumbnail_venue", "detail_venue_image"]

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
    override func favoriteAction(sender: AnyObject) {
        super.favoriteAction(sender)
        didAddFavorite = !didAddFavorite
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
            return UITableViewCell()
        }
        switch detailVenueSection {
        case .PageImage:
            return UITableViewCell()
        case .Information:
            guard let infomationSection = InfomationSection(rawValue: indexPath.row) else {
                return UITableViewCell()
            }
            let cell = tableView.dequeue(DefaultVenueDetailCell)
            cell.titleLabel.text = infomationSection.title
            switch infomationSection {
            case .Name:
                cell.textDetailLabel.text = "Phố xưa"
                return cell
            case .Address:
                let cellMap = tableView.dequeue(MapDetailVenueCell)
                cellMap.addressLabel.text = "17 Phan Đình Phùng, Hải Châu, Đà Nẵng"
                cellMap.detailVenueViewController = self
                return cellMap
            case .Contact:

                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = "0935307484"
                return cell
            case .Categories:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = "Coffee Shop"
                return cell
            case .Hours:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = "11:00~21:00"
                return cell
            case .Rating:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = "8.2"
                return cell
            case .PriceTier:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = "2"
                return cell
            case .Verified:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = "Yes"
                return cell
            case .Website:
                cell.titleLabel.text = infomationSection.title
                cell.textDetailLabel.text = "thiendia.com"
                return cell
            }
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
            // self.addChildViewController(view.imagePageViewController!)
            view.imageNames = self.imageNames
            return view
        case .Information:
            view.titleHeader.text = Strings.DetailVenueTitleInformation
        case .Tips:
            view.titleHeader.text = Strings.DetailVenueTitleTips
        }
        return view
    }
}
