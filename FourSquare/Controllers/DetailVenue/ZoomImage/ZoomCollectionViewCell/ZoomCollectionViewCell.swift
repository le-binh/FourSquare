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
    @IBOutlet private(set) weak var imageScrollView: UIScrollView!
    @IBOutlet private(set) weak var venueImageView: UIImageView!
    @IBOutlet private(set) weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var imageViewTopConstraint: NSLayoutConstraint!
    var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureScrollViewToZoom()
        self.configureTapGesture()
        self.configureActivityIndicator()
    }

    func configureImageView() {
        let imageSize = self.venueImageView.frame.size
        self.imageViewLeadingConstraint.constant = (kScreenSize.width - imageSize.width) / 2
        self.imageViewTopConstraint.constant = (kScreenSize.height - imageSize.height) / 2
    }

    func setPhoto(photo: Photo) {
        self.venueImageView.image = nil
        self.activityIndicator.startAnimating()
        let widthPhoto: CGFloat = CGFloat(photo.width)
        let heightPhoto: CGFloat = CGFloat(photo.height)
        let minRatio = min(kScreenSize.width / widthPhoto, kScreenSize.height / heightPhoto)
        self.venueImageView.bounds.size = CGSize(width: widthPhoto * minRatio, height: heightPhoto * minRatio)
        self.configureImageView()
        let path = photo.photoPathString
        if let url = NSURL(string: path) {
            self.venueImageView.hnk_setImageFromURL(url, success: { (image) in
                self.venueImageView.image = image
                self.activityIndicator.stopAnimating()
            })
        }
    }

    func configureScrollViewToZoom() {
        self.imageScrollView.minimumZoomScale = 1.0
        self.imageScrollView.maximumZoomScale = 1.5
        self.imageScrollView.zoomScale = 1.0
        self.imageScrollView.delegate = self
    }

    func configureActivityIndicator() {
        let indicatorSize: CGFloat = 50
        let originX = (kScreenSize.width - indicatorSize) / 2
        let originY = (kScreenSize.height - indicatorSize) / 2
        let frame = CGRect(x: originX, y: originY, width: indicatorSize, height: indicatorSize)
        activityIndicator = UIActivityIndicatorView(frame: frame)
        self.activityIndicator.hidesWhenStopped = true
        self.contentView.addSubview(activityIndicator)
    }

    func configureTapGesture() {
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomWhenDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        self.imageScrollView.addGestureRecognizer(doubleTap)
    }

    func zoomWhenDoubleTap(recognizer: UITapGestureRecognizer) {
        if self.imageScrollView.zoomScale > 1 {
            self.imageScrollView.setZoomScale(1, animated: true)
        } else {
            let point = recognizer.locationInView(recognizer.view)
            if checkPointOnImage(point) {
                zoomToPoint(point, scale: 1.5, animated: true)
            }
        }
    }

    func checkPointOnImage(point: CGPoint) -> Bool {
        let minPoint: CGPoint = self.venueImageView.frame.origin
        let imageWidth = self.venueImageView.frame.width
        let imageHeight = self.venueImageView.frame.height
        let maxPoint: CGPoint = CGPoint(x: minPoint.x + imageWidth, y: minPoint.y + imageHeight)
        if (point.x > minPoint.x && point.y > minPoint.y) && (point.x < maxPoint.x && point.y < maxPoint.y) {
            return true
        }
        return false
    }

    func zoomToPoint(point: CGPoint, scale: CGFloat, animated: Bool) {
        var zoomPoint: CGPoint = CGPoint()
        let scrollViewContentSize = self.imageScrollView.contentSize
        let scrollViewSize = self.imageScrollView.bounds.size
        let currentScale = self.imageScrollView.zoomScale
        let zoomContentSize: CGSize = CGSize(width: scrollViewContentSize.width / currentScale, height: scrollViewContentSize.height / currentScale)
        zoomPoint.x = (point.x / scrollViewContentSize.width) * zoomContentSize.width
        zoomPoint.y = (point.y / scrollViewContentSize.height) * zoomContentSize.height

        let zoomSize: CGSize = CGSize(width: scrollViewSize.width / scale, height: scrollViewSize.height / scale)
        let zoomRect: CGRect = CGRect(x: zoomPoint.x - zoomSize.width / 2, y: zoomPoint.y - zoomSize.height / 2, width: zoomSize.width, height: zoomSize.height)
        self.imageScrollView.zoomToRect(zoomRect, animated: true)
    }
}

// MARK:- ScrollView Delegate
extension ZoomCollectionViewCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.venueImageView
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageHeight = self.venueImageView.frame.height
        UIView.animateWithDuration(0.2, animations: {
            self.imageViewTopConstraint.constant = (kScreenSize.height - imageHeight) / 2
            self.layoutIfNeeded()
        }) { (completion) in
        }
    }
}
