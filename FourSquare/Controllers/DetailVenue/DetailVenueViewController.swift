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
import Haneke

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

    @IBOutlet private weak var detailVenueTableView: UITableView!
    @IBOutlet private weak var commentView: UIView!
    @IBOutlet private weak var bottomCommentViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var commentTextView: UITextView!
    var venue: Venue?

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureCommentView()
        self.setNavigationBarTitle(venue?.name)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configureInsetTableView()
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

    override func backAction(sender: AnyObject) {
        super.backAction(sender)
        if let venue = self.venue {
            RealmManager.sharedInstance.deleteDetailVenue(venue)
            Shared.imageCache.removeAll()
        }
    }

    // MARK:- Actions

    @IBAction func commentAction(sender: AnyObject) {
        self.resetCommentView()
        guard let textComment = commentTextView.text else {
            return
        }
        if textComment.isEmpty {
            self.errorMessageComment(Strings.ErrorTitle, message: Strings.EmptyCommentError)
            return
        }
        let user = UserRealmManager.sharedInstance.getUser()
        if user == nil {
            self.showLoginQuestionPopup()
        } else {
            if let venue = self.venue {
                CommentService().commentTips(venue.id, commentText: textComment, completion: { (completion) in
                    if completion {
                        self.insertCommentToTableView()
                    }
                })
            }
            self.commentTextView.text = ""
        }
    }

    // MARK:- Private Functions

    private func configureTableView() {
        self.detailVenueTableView.registerNib(ViewHeaderVenueDetail)
        self.detailVenueTableView.registerNib(DefaultVenueDetailCell)
        self.detailVenueTableView.registerNib(MapDetailVenueCell)
        self.detailVenueTableView.registerNib(TipsDetailVenueCell)
        self.detailVenueTableView.registerNib(ImagesCollectionViewHeader)
        self.detailVenueTableView.delegate = self
        self.detailVenueTableView.dataSource = self
        self.detailVenueTableView.rowHeight = UITableViewAutomaticDimension
        self.detailVenueTableView.estimatedRowHeight = 51
        self.detailVenueTableView.setSeparatorInsets(UIEdgeInsetsZero)
    }

    private func configureInsetTableView() {
        self.detailVenueTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.commentView.frame.height, right: 0)
    }

    private func configureCommentView() {
        self.commentView.hidden = true
        self.commentTextView.delegate = self
        self.commentTextView.cornerRadiusWith(2)
        self.commentTextView.autocorrectionType = .No
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
        if let photos = self.venue?.photos, tips = self.venue?.tips {
            if !photos.isEmpty && !tips.isEmpty {
                return
            }
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.Clear)
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
        VenueService().loadVenueHours(venue.id, section: venue.section) { (error) in
            completion()
        }
    }

    private func loadVenuePhotos(completion: () -> Void) {
        guard let venue = self.venue else {
            completion()
            return
        }
        VenueService().loadVenuePhotos(venue.id, section: venue.section) { (error) in
            completion()
        }
    }

    private func loadVenueTips(completion: () -> Void) {
        guard let venue = self.venue else {
            completion()
            return
        }
        VenueService().loadVenueTips(venue.id, section: venue.section) { (error) in
            completion()
        }
    }

    private func informationCell(venue: Venue, tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        guard let infomationSection = InfomationSection(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeue(DefaultVenueDetailCell)
        cell.setTitleLabelText(infomationSection.title)
        switch infomationSection {
        case .Name:
            cell.setDetailLabelText(venue.name)
        case .Address:
            let cellMap = tableView.dequeue(MapDetailVenueCell)
            cellMap.venue = venue
            cellMap.delegate = self
            return cellMap
        case .Contact:
            guard let contact = venue.contact?.contact else { break }
            cell.setDetailLabelText(contact.isEmpty ? Strings.NotAvailable : contact)
        case .Categories:
            cell.setDetailLabelText(venue.showCategories)
        case .Hours:
            cell.setDetailLabelText(venue.hours?.timeToday ?? Strings.NotAvailable)
        case .Rating:
            cell.setDetailLabelText(String(venue.rating))
        case .PriceTier:
            cell.setDetailLabelText(String(venue.price?.tier ?? 0))
        case .Verified:
            cell.setDetailLabelText(venue.verified ? Strings.YesString : Strings.NoString)
        case .Website:
            cell.setDetailLabelText(venue.website.isEmpty ? Strings.NotAvailable : venue.website)
        }
        return cell
    }

    private func moveCommentView() {
        self.bottomCommentViewLayoutConstraint.constant = 216
        UIView.animateWithDuration(0.25) {
            self.view.layoutIfNeeded()
        }
    }

    private func resetCommentView() {
        self.commentTextView.endEditing(true)
        self.bottomCommentViewLayoutConstraint.constant = 0
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func showLoginQuestionPopup() {
        let alert = UIAlertController(title: Strings.Login, message: Strings.QuestionToLogin, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Strings.Login, style: .Default, handler: { (action) in
            dispatch_async(dispatch_get_main_queue(), {
                LoginService().login()
            })
            }))
        alert.addAction(UIAlertAction(title: Strings.NoString, style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    private func showSuccessCommentPopup() {
        let alert = UIAlertController(title: Strings.Login, message: Strings.QuestionToLogin, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Strings.Login, style: .Default, handler: { (action) in
            dispatch_async(dispatch_get_main_queue(), {
                LoginService().login()
            })
            }))
        alert.addAction(UIAlertAction(title: Strings.NoString, style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    private func insertCommentToTableView() {
        guard let venue = self.venue else {
            return
        }
        let indexRow = venue.tips.count - 1
        let indexPath: NSIndexPath = NSIndexPath(forRow: indexRow, inSection: 2)
        self.detailVenueTableView.beginUpdates()
        self.detailVenueTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        self.detailVenueTableView.endUpdates()
        self.detailVenueTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }

    private func errorMessageComment(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Strings.OKString, style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK:- Table View Datasource

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

// MARK:- Table View Delegate

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
            let view = tableView.dequeue(ImagesCollectionViewHeader)
            guard let venue = self.venue else {
                return view
            }
            view.detailVenueViewController = self
            view.photos = venue.photos
            return view
        case .Information:
            view.setTitleHeaderText(Strings.DetailVenueTitleInformation)
        case .Tips:
            view.setTitleHeaderText(Strings.DetailVenueTitleTips)
        }
        return view
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView != self.detailVenueTableView {
//            print(round((scrollView.contentSize.height / scrollView.frame.height - (17 / 15)) / 0.6))
            return
        }
        if scrollView.contentOffset.y > 50 {
            self.commentView.hidden = false
        } else {
            self.commentView.hidden = true
            self.resetCommentView()
        }
    }

    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if scrollView != self.detailVenueTableView {
            return
        }
        self.resetCommentView()
    }
}

// MARK:- Zoom Collection View Delegate

extension DetailVenueViewController: ZoomImagesViewControllerDelegate {
    func scrollCollectionView(index: Int) {
        let imagesCollectionViewHeader = self.detailVenueTableView.headerViewForSection(0) as? ImagesCollectionViewHeader
        imagesCollectionViewHeader?.scrollToCellAtIndex(index, animated: false)
    }
}

// MARK:- Text View Delegate

extension DetailVenueViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.moveCommentView()
        return true
    }
}

// MARK:- MapDetailVenueDelegate

extension DetailVenueViewController: MapDetailVenueCellDelegate {
    func showMapDetailVenue() {
        let mapDetailVenueViewController = MapDetailVenueViewController.vc()
        mapDetailVenueViewController.venue = venue
        mapDetailVenueViewController.title = venue?.name
        self.navigationController?.pushViewController(mapDetailVenueViewController, animated: true)
    }
}
