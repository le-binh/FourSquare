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
    let numberOfItems: Int = 4
    var indexMarker: Int = 0
    var markers: [GMSMarker] = []
    var locationDegrees: [(Double, Double)] = [(16.071574, 108.234338), (16.077554, 108.231892), (16.075863, 108.238329), (16.072523, 108.230476)]

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureGoogleMapsView()
        // Example Marker
        self.addMultiMarker()
    }

    // MARK:- Action

    @IBAction func backCollectionCellAction(sender: AnyObject) {
        let contentOffsetX = self.venueCollectionView.contentOffset.x
        let index = Int(contentOffsetX / self.venueCollectionView.bounds.width) - 1
        if index < 0 {
            return
        }
        self.scrollToCellAtIndex(index)
    }

    @IBAction func nextCollectionCellAction(sender: AnyObject) {
        let contentOffsetX = self.venueCollectionView.contentOffset.x
        let index = Int(contentOffsetX / self.venueCollectionView.bounds.width) + 1
        if index == self.numberOfItems {
            return
        }
        self.scrollToCellAtIndex(index)
    }

    // MARK:- Private Functions

    private func configureCollectionView() {
        self.venueCollectionView.backgroundColor = UIColor.clearColor()
        self.venueCollectionView.delegate = self
        self.venueCollectionView.dataSource = self
        self.venueCollectionView.registerNib(VenueCollectionViewCell)
    }

    private func scrollToCellAtIndex(index: Int) {
        let indexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
        self.venueCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }

    private func configureGoogleMapsView() {
        self.venueMapView.delegate = self
    }

    private func addMarker(lat: Double, _ long: Double) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        marker.zIndex = Int32(self.indexMarker)
        if marker.zIndex == 0 {
            marker.icon = UIImage(named: "selected_marker_ic")
            marker.title = "abc"
            self.markers.append(marker)
            marker.map = self.venueMapView
            self.venueMapView.selectedMarker = marker
        } else {
            marker.icon = UIImage(named: "marker_ic")
            self.markers.append(marker)
            marker.map = self.venueMapView
        }

        self.venueMapView.camera = GMSCameraPosition(target: marker.position, zoom: 14, bearing: 0, viewingAngle: 0)
        self.indexMarker += 1
    }

    private func addMultiMarker() {
        self.indexMarker = 0
        for i in 0..<self.locationDegrees.count {
            let item = self.locationDegrees[i]
            addMarker(item.0, item.1)
        }
    }

    private func resetMarkersIconWithout(selectedMarker: GMSMarker) {
        for item in self.markers {
            if item.position.latitude != selectedMarker.position.latitude || item.position.longitude != selectedMarker.position.longitude {
                item.icon = UIImage(named: "marker_ic")
            }
        }
    }

    private func setSelectedMarker(selectedMarker: GMSMarker) {
        selectedMarker.icon = UIImage(named: "selected_marker_ic")
        self.venueMapView.selectedMarker = selectedMarker
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
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVenueViewController = DetailVenueViewController.vc()
        detailVenueViewController.title = "Phố xưa"
        self.navigationController?.pushViewController(detailVenueViewController, animated: true)
    }
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
        let marker = self.markers[index]
        self.setSelectedMarker(marker)
        self.resetMarkersIconWithout(marker)
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let contentOffsetX = self.venueCollectionView.contentOffset.x
        let index = Int(contentOffsetX / self.venueCollectionView.bounds.width)
        let marker = self.markers[index]
        self.setSelectedMarker(marker)
        self.resetMarkersIconWithout(marker)
    }
}

//MARK:- Google Map Delegate

extension MapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        self.setSelectedMarker(marker)
        resetMarkersIconWithout(marker)
        self.scrollToCellAtIndex(Int(marker.zIndex))
        return true
    }
}
