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
    var photos = RealmSwift.List<Photo>() {
        didSet {
            self.imagesCollectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        self.configureCollectionView()
    }
    @IBAction func backImageAction(sender: AnyObject) {

    }
    @IBAction func nextImageAction(sender: AnyObject) {

    }

    func configureCollectionView() {
        self.imagesCollectionView.registerNib(ImagesCollectionViewCell)
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.dataSource = self
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
        let photo = self.photos[indexPath.row]
        print(photo.photoPathString)
    }

}
