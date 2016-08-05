//
//  DetailVenueViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/4/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class DetailVenueViewController: BaseViewController {

    // MARK:- Properties

    @IBOutlet weak var imagesPageView: UIView!
    @IBOutlet weak var detailVenueTableView: UITableView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    private var imagePageViewController: UIPageViewController?
    @IBOutlet weak var beforePageButton: UIButton!
    @IBOutlet weak var afterPageButton: UIButton!

    private let imageNames = ["detail_venue_image", "thumbnail_venue", "detail_venue_image"]

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureImagePageViewController()
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
        if currentIndex == 0 {
            self.beforePageButton.hidden = true
        } else {
            self.beforePageButton.hidden = false
        }
        if currentIndex == self.imageNames.count {
            self.afterPageButton.hidden = true
        } else {
            self.afterPageButton.hidden = false
        }
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
