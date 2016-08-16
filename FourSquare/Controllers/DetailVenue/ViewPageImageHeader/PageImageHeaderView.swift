//
//  PageImageHeaderView.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/8/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class PageImageHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imagesPageView: UIView!
    @IBOutlet weak var beforePageButton: UIButton!
    @IBOutlet weak var afterPageButton: UIButton!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    var imagePageViewController: UIPageViewController?

    var photos: [Photo] = [] {
        didSet {
            self.afterPageButton.hidden = self.photos.count <= 1
            self.imagesPageControl.numberOfPages = self.photos.count
            self.setFirstControllerOfPageViewController()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureImagePageViewController()
    }

    @IBAction func didTabBackAction(sender: AnyObject) {
        self.scrollToBackViewController()
    }

    @IBAction func didTabNextAction(sender: AnyObject) {
        self.scrollToNextViewController()
    }

    // MARK:- Private Functions

    private func configureImagePageViewController() {
        self.createImagePageViewController()
        self.setUpImagesPageControler()
        self.beforePageButton.hidden = true
    }

    private func createImagePageViewController() {
        imagePageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.imagePageViewController?.dataSource = self
        self.imagePageViewController?.delegate = self
        let imagePageItemViewController = ImagePageItemViewController.vc()
        let startingViewControllers = [imagePageItemViewController]
        imagePageViewController?.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        guard let pageViewController = self.imagePageViewController else {
            return
        }
        self.imagesPageView.addSubview(pageViewController.view)
        pageViewController.view.frame = self.imagesPageView.bounds
    }

    private func setFirstControllerOfPageViewController() {
        if !photos.isEmpty {
            guard let firstController = getPageItemViewController(0) else {
                return
            }
            let startingViewControllers = [firstController]
            imagePageViewController?.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        }
    }

    private func setUpImagesPageControler() {
        self.imagesPageControl.numberOfPages = self.photos.count
        self.imagesPageControl.currentPage = 0
    }

    private func setUpImagePageViewController() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
    }

    private func getPageItemViewController(itemIndex: Int) -> ImagePageItemViewController? {
        if itemIndex < 0 || itemIndex >= photos.count { return nil }
        let imagePageItemViewController = ImagePageItemViewController.vc()
        imagePageItemViewController.itemIndex = itemIndex
        imagePageItemViewController.photoPathString = photos[itemIndex].photoPathString
        return imagePageItemViewController
    }

    private func setCurrentPage() {
        self.imagesPageControl.currentPage = self.currentControllerIndex()
    }

    private func scrollToNextViewController() {
        if self.currentControllerIndex() == self.photos.count {
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
        self.beforePageButton.hidden = currentIndex == 0
        self.afterPageButton.hidden = currentIndex == self.photos.count - 1
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

extension PageImageHeaderView: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.checkCurrentPageToHiddenButton()
            self.setCurrentPage()
        }
    }
}

//MARK:- Page View Controller DataSource

extension PageImageHeaderView: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        self.setCurrentPage()
        guard let pageItemViewController = viewController as? ImagePageItemViewController else {
            return nil
        }
        let currentIndex = pageItemViewController.itemIndex
        return getPageItemViewController(currentIndex - 1)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        self.setCurrentPage()
        guard let pageItemViewController = viewController as? ImagePageItemViewController else {
            return nil
        }
        let currentIndex = pageItemViewController.itemIndex
        return getPageItemViewController(currentIndex + 1)
    }
}
