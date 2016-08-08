//
//  MapViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/8/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftUtils

class MapViewController: UIViewController {

    // MARK:- Properties

    @IBOutlet weak var venueMapView: GMSMapView!
    @IBOutlet weak var venueCollectionView: UICollectionView!
    @IBOutlet weak var backCollectionCellButton: UIButton!
    @IBOutlet weak var nextCollectionCellButton: UIButton!
    let collectionCellPadding: CGFloat = 10
    let numberOfItems: Int = 5

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.setupUI()
    }

    // MARK:- Action

    @IBAction func backCollectionCellAction(sender: AnyObject) {
        let contentOffsetX = self.venueCollectionView.contentOffset.x
        let index = Int(contentOffsetX / self.venueCollectionView.bounds.width) - 1
        if index < 0 {
            return
        }
        let indexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
        self.venueCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }

    @IBAction func nextCollectionCellAction(sender: AnyObject) {
        let contentOffsetX = self.venueCollectionView.contentOffset.x
        let index = Int(contentOffsetX / self.venueCollectionView.bounds.width) + 1
        if index == self.numberOfItems {
            return
        }
        let indexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
        self.venueCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }

    // MARK:- Private Functions
    private func configureCollectionView() {
        self.venueCollectionView.backgroundColor = UIColor.clearColor()
        self.venueCollectionView.delegate = self
        self.venueCollectionView.dataSource = self
        self.venueCollectionView.registerNib(VenueCollectionViewCell)
    }

}

//MARK:- Collection View DataSource

extension MapViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(VenueCollectionViewCell.self, forIndexPath: indexPath)
        return cell
    }
}

//MARK:- Collection View Delegate

extension MapViewController: UICollectionViewDelegate {

}

//MARK:- Collection View Delegate Flow Layout

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = self.venueCollectionView.frame.width - 2 * self.collectionCellPadding
        let cellHeight = self.venueCollectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

//MARK:- Scroll View Delegate
extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let contentOffsetX = self.venueCollectionView.contentOffset.x
        let index = Int(contentOffsetX / self.venueCollectionView.bounds.width)
        print(index)
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let contentOffsetX = self.venueCollectionView.contentOffset.x
        let index = Int(contentOffsetX / self.venueCollectionView.bounds.width)
        print(index)
    }
}
