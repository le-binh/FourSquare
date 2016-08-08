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
    var imageName: String = "" {
        didSet {
            if let imageView = venueImageView {
                imageView.image = UIImage(named: imageName)
                self.venueImageView.image = imageView.image
            }
        }
    }

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.venueImageView.image = UIImage(named: self.imageName)
    }

}
