//
//  ImagesCollectionViewHeader.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/22/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import RealmSwift

class ImagesCollectionViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var backImageButton: UIButton!
    @IBOutlet weak var nextImageButton: UIButton!

    var detailVenueViewController = DetailVenueViewController()

    var photos = RealmSwift.List<Photo>() {
        didSet {
            self.nextImageButton.hidden = self.photos.count <= 1
            self.imagesCollectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        self.configureCollectionView()
    }

    @IBAction func backImageAction(sender: AnyObject) {
        let indexRow = self.visibleIndex() - 1
        if indexRow < 0 {
            return
        }
        self.scrollToCellAtIndex(indexRow, animated: true)
    }

    @IBAction func nextImageAction(sender: AnyObject) {
        let indexRow = self.visibleIndex() + 1
        if indexRow == self.photos.count {
            return
        }
        self.scrollToCellAtIndex(indexRow, animated: true)
    }

    func configureCollectionView() {
        self.imagesCollectionView.registerNib(ImagesCollectionViewCell)
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
        self.backImageButton.hidden = true
    }

    private func visibleIndex() -> Int {
        guard let indexPathVisible = self.imagesCollectionView.indexPathsForVisibleItems().first else {
            return -1
        }
        return indexPathVisible.row
    }

    private func scrollToCellAtIndex(index: Int, animated: Bool) {
        let indexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
        self.imagesCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
        self.checkCurrentIndexToHiddenButton(index)
    }

    private func checkCurrentIndexToHiddenButton(index: Int) {
        self.backImageButton.hidden = index == 0
        self.nextImageButton.hidden = index == self.photos.count - 1
    }
}

extension ImagesCollectionViewHeader: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let contentOffsetX = self.imagesCollectionView.contentOffset.x
        let collectionWidth = self.imagesCollectionView.bounds.width
        let index = Int(contentOffsetX / collectionWidth)
        self.checkCurrentIndexToHiddenButton(index)
    }
}

extension ImagesCollectionViewHeader: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ImagesCollectionViewCell.self, forIndexPath: indexPath)
        let photo = photos[indexPath.row]
        cell.setPhoto(photo)
        return cell
    }
}

extension ImagesCollectionViewHeader: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let imageSize: CGSize = self.imagesCollectionView.frame.size
        return imageSize
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let zoomCollectionView = ZoomImagesViewController.vc()
        zoomCollectionView.photos = self.photos
        zoomCollectionView.indexPath = indexPath
        self.detailVenueViewController.presentViewController(zoomCollectionView, animated: true, completion: nil)
    }

}
