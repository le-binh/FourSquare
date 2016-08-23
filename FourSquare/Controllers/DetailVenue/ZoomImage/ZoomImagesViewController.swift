//
//  ZoomImagesViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/22/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftUtils

class ZoomImagesViewController: UIViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var photos = RealmSwift.List<Photo>()
    var indexPath: NSIndexPath = NSIndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imagesCollectionView.scrollToItemAtIndexPath(self.indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
    }

    @IBAction func closeZoomViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func configureCollectionView() {
        self.imagesCollectionView.registerNib(ZoomCollectionViewCell)
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
    }
}

extension ZoomImagesViewController: UIScrollViewDelegate {

}

extension ZoomImagesViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ZoomCollectionViewCell.self, forIndexPath: indexPath)
        let photo = self.photos[indexPath.row]
        cell.setPhoto(photo)
        return cell
    }
}

extension ZoomImagesViewController: UICollectionViewDelegate {

}

extension ZoomImagesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return kScreenSize
    }
}
