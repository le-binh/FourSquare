//
//  ZoomCollectionViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/22/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import SwiftUtils

class ZoomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var venueImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setPhoto(photo: Photo) {
        let widthPhoto: CGFloat = CGFloat(photo.width)
        let heightPhoto: CGFloat = CGFloat(photo.height)
        let minRatio = min(widthPhoto / kScreenSize.width, heightPhoto / kScreenSize.height)
        self.venueImageView.bounds.size = CGSize(width: widthPhoto / minRatio, height: heightPhoto / minRatio)
        let path = photo.photoPathString
        if let url = NSURL(string: path) {
            self.venueImageView.hnk_setImageFromURL(url)
        }
    }

}
