//
//  ImagePageItemViewController.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/5/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit

class ImagePageItemViewController: UIViewController {

    // MARK:- Properties

    @IBOutlet weak var venueImageView: UIImageView!
    var itemIndex: Int = 0
    var photoPathString: String = "" {
        didSet {
            if let imageView = venueImageView {
                if let url = NSURL(string: photoPathString) {
                    imageView.hnk_setImageFromURL(url)
                    self.venueImageView.image = imageView.image
                }
            }
        }
    }
    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = NSURL(string: photoPathString) {
            self.venueImageView.hnk_setImageFromURL(url)
        }
    }

}
