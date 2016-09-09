//
//  ImagesCollectionViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/22/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import Haneke
import SwiftUtils

class ImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private(set) weak var venueImageView: UIImageView!
    var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureActivityIndicator()
    }

    func setPhoto(photo: Photo) {
        self.venueImageView.image = nil
        self.activityIndicator.startAnimating()
        let path = photo.photoPathString
        if let url = NSURL(string: path) {
            self.venueImageView.hnk_setImageFromURL(url, success: { (image) in
                self.venueImageView.image = image
                self.activityIndicator.stopAnimating()
            })
        }
    }

    func configureActivityIndicator() {
        let indicatorSize: CGFloat = 50
        let originX = (kScreenSize.width - indicatorSize) / 2
        let originY = ((2 / 3) * kScreenSize.width - indicatorSize) / 2
        let frame = CGRect(x: originX, y: originY, width: indicatorSize, height: indicatorSize)
        activityIndicator = UIActivityIndicatorView(frame: frame)
        self.activityIndicator.hidesWhenStopped = true
        self.contentView.addSubview(activityIndicator)
    }

}
