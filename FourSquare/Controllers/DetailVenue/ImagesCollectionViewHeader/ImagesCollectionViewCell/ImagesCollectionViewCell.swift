//
//  ImagesCollectionViewCell.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/22/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var venueImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setPhoto(photo: Photo) {
        self.venueImageView.image = UIImage(named: "thumbnail_venue")
        let path = photo.photoPathString
        if let url = NSURL(string: path) {
            self.venueImageView.hnk_setImageFromURL(url)
        }
    }

}
