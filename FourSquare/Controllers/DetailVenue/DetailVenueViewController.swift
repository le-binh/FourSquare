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
    private var imagePageViewController: UIPageViewController?

    private let imageNames = ["thumbnail_venue"]

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureImagePageViewController()
    }

    // MARK:- Private Functions

    private func configureImagePageViewController() {
        self.createImagePageViewController()
        self.setUpImagePageViewController()
    }

    private func createImagePageViewController() {
        imagePageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.imagePageViewController?.dataSource = self

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
        pageViewController.didMoveToParentViewController(self)

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
}

//MARK:- Page View Controller DataSource

extension DetailVenueViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let pageItemViewController = viewController as? ImagePageItemViewController else {
            return nil
        }
        if pageItemViewController.itemIndex > 0 {
            return getPageItemViewController(pageItemViewController.itemIndex - 1)
        }
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let pageItemViewController = viewController as? ImagePageItemViewController else {
            return nil
        }
        if pageItemViewController.itemIndex + 1 < imageNames.count {
            return getPageItemViewController(pageItemViewController.itemIndex + 1)
        }
        return nil
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.imageNames.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
