//
//  DetailVenueViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

enum DetailVenueSection: Int {
    case Information
    case Tips
    var title: String {
        switch self {
        case .Information:
            return Strings.DetailVenueTitleInformation
        case .Tips:
            return Strings.DetailVenueTitleTips
        }
    }
    var numberOfRow: Int {
        switch self {
        case .Information:
            return 9
        case .Tips:
            return 5
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

    @IBOutlet weak var imagesPageView: UIView!
    @IBOutlet weak var detailVenueTableView: UITableView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    private var imagePageViewController: UIPageViewController?
    @IBOutlet weak var beforePageButton: UIButton!
    @IBOutlet weak var afterPageButton: UIButton!

    let sectionTableViewHeight: CGFloat = 30

    private let imageNames = ["detail_venue_image", "thumbnail_venue", "detail_venue_image"]

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureImagePageViewController()
        self.configureTableView()
    }

    // MARK:- Action

    @IBAction func didTapBackAction(sender: AnyObject) {
        self.scrollToBackViewController()
    }

    @IBAction func didTapNextAction(sender: AnyObject) {
        self.scrollToNextViewController()
    }

    // MARK:- Private Functions

    private func configureImagePageViewController() {
        self.createImagePageViewController()
        self.setUpImagesPageControler()
        self.beforePageButton.hidden = true
    }

    private func configureTableView() {
        self.detailVenueTableView.registerNib(ViewHeaderVenueDetail)
        self.detailVenueTableView.registerNib(DefaultVenueDetailCell)
        self.detailVenueTableView.registerNib(MapDetailVenueCell)
        self.detailVenueTableView.registerNib(TipsDetailVenueCell)
        self.detailVenueTableView.delegate = self
        self.detailVenueTableView.dataSource = self
        self.detailVenueTableView.rowHeight = UITableViewAutomaticDimension
        self.detailVenueTableView.estimatedRowHeight = 51
    }

    private func createImagePageViewController() {
        imagePageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.imagePageViewController?.dataSource = self
        self.imagePageViewController?.delegate = self
        if imageNames.count > 0 {
            guard let firstController = getPageItemViewController(0) else {
                return
            }
            let startingViewControllers = [firstController]
            imagePageViewController?.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        }
        guard let pageViewController = self.imagePageViewController else {
            return
        }
        self.addChildViewController(pageViewController)
        self.imagesPageView.addSubview(pageViewController.view)
        pageViewController.view.frame = self.imagesPageView.bounds
        pageViewController.didMoveToParentViewController(self)
    }

    private func setUpImagesPageControler() {
        self.imagesPageControl.numberOfPages = self.imageNames.count
        self.imagesPageControl.currentPage = 0
    }

    private func setUpImagePageViewController() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
    }

    private func getPageItemViewController(itemIndex: Int) -> ImagePageItemViewController? {
        if itemIndex < imageNames.count {
            let imagePageItemViewController = ImagePageItemViewController.vc()
            imagePageItemViewController.itemIndex = itemIndex
            imagePageItemViewController.imageName = imageNames[itemIndex]
            return imagePageItemViewController
        }
        return nil
    }

    private func setCurrentPage() {
        self.imagesPageControl.currentPage = self.currentControllerIndex()
    }

    private func scrollToNextViewController() {
        if self.currentControllerIndex() == self.imageNames.count {
            return
        }
        guard let imagePageViewController: UIPageViewController = self.imagePageViewController else {
            return
        }
        if let currentViewController = self.currentController(), nextViewController = pageViewController(imagePageViewController, viewControllerAfterViewController: currentViewController) {
            self.scrollToViewController(nextViewController)
        }
    }

    private func scrollToViewController(viewController: UIViewController,
        direction: UIPageViewControllerNavigationDirection = .Forward) {
            guard let imagePageViewController: UIPageViewController = self.imagePageViewController else {
                return
            }
            imagePageViewController.setViewControllers([viewController],
                direction: direction,
                animated: true,
                completion: { (finished) -> Void in
                    self.checkCurrentPageToHiddenButton()
                    self.setCurrentPage()
            })
    }

    private func scrollToBackViewController() {
        if self.currentControllerIndex() == 0 {
            return
        }
        guard let imagePageViewController: UIPageViewController = self.imagePageViewController else {
            return
        }
        if let currentViewController = self.currentController(), backViewController = pageViewController(imagePageViewController, viewControllerBeforeViewController: currentViewController) {
            self.scrollToViewController(backViewController, direction: .Reverse)
        }
    }

    private func checkCurrentPageToHiddenButton() {
        let currentIndex = self.currentControllerIndex()
        self.beforePageButton.hidden = (currentIndex == 0) ? true : false
        self.afterPageButton.hidden = (currentIndex == self.imageNames.count - 1) ? true : false
    }

    // MARK:- Public Functions

    func currentControllerIndex() -> Int {
        let pageItemController = self.currentController()
        if let controller = pageItemController as? ImagePageItemViewController {
            return controller.itemIndex
        }
        return -1
    }

    func currentController() -> UIViewController? {
        if self.imagePageViewController?.viewControllers?.count > 0 {
            return self.imagePageViewController?.viewControllers?[0]
        }
        return nil
    }
}

//MARK:- Page View Controller Delegate

extension DetailVenueViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.checkCurrentPageToHiddenButton()
            self.setCurrentPage()
        }
    }
}

//MARK:- Page View Controller DataSource

extension DetailVenueViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        self.setCurrentPage()
        guard let pageItemViewController = viewController as? ImagePageItemViewController else {
            return nil
        }
        if pageItemViewController.itemIndex > 0 {
            return getPageItemViewController(pageItemViewController.itemIndex - 1)
        }
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        self.setCurrentPage()
        guard let pageItemViewController = viewController as? ImagePageItemViewController else {
            return nil
        }
        if pageItemViewController.itemIndex + 1 < imageNames.count {
            return getPageItemViewController(pageItemViewController.itemIndex + 1)
        }
        return nil
    }
}

//MARK:- Table View Datasource

extension DetailVenueViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
        return self.sectionTableViewHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let detailVenueSection = DetailVenueSection(rawValue: section) else {
            return nil
        }
        let view = tableView.dequeue(ViewHeaderVenueDetail)
        switch detailVenueSection {
        case .Information:
            view.titleHeader.text = "Information"
        case .Tips:
            view.titleHeader.text = "Tips"
        }
        return view
    }
}
