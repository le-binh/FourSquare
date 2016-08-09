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
    var markers: [MarkerMap] = []
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
        let indexRow = self.indexVisible() - 1
        if indexRow < 0 {
            return
        }
        self.scrollToCellAtIndex(indexRow)
    }

    @IBAction func nextCollectionCellAction(sender: AnyObject) {
        let indexRow = self.indexVisible() + 1
        if indexRow == self.numberOfItems {
            return
        }
        self.scrollToCellAtIndex(indexRow)
    }

    // MARK:- Private Functions

    private func configureCollectionView() {
        self.venueCollectionView.backgroundColor = UIColor.clearColor()
        self.venueCollectionView.delegate = self
        self.venueCollectionView.dataSource = self
        self.venueCollectionView.registerNib(VenueCollectionViewCell)
        self.configureCollectionViewFlowLayout()
    }

    private func configureCollectionViewFlowLayout() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .Horizontal
        collectionViewFlowLayout.minimumLineSpacing = 2 * self.collectionCellPadding
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: self.collectionCellPadding, bottom: 0, right: self.collectionCellPadding)
        collectionViewFlowLayout.itemSize = self.sizeItemCellOfCollectionView()
        self.venueCollectionView.collectionViewLayout = collectionViewFlowLayout
    }

    private func sizeItemCellOfCollectionView() -> CGSize {
        let cellWidth = kScreenSize.width - 2 * self.collectionCellPadding
        let cellHeight = self.venueCollectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }

    private func scrollToCellAtIndex(index: Int) {
        let indexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
        self.venueCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }

    private func configureGoogleMapsView() {
        self.venueMapView.delegate = self
    }

    private func addMarker(lat: Double, _ long: Double) {
        let marker = MarkerMap()
        marker.position = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
        marker.tag = self.indexMarker
        if marker.tag == 0 {
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
        for element in self.locationDegrees {
            addMarker(element.0, element.1)
        }
    }

    private func resetMarkersIconWithout(selectedMarker: MarkerMap) {
        for item in self.markers {
            if item.position.latitude != selectedMarker.position.latitude || item.position.longitude != selectedMarker.position.longitude {
                item.icon = UIImage(named: "marker_ic")
            }
        }
    }

    private func setSelectedMarker(selectedMarker: MarkerMap) {
        selectedMarker.icon = UIImage(named: "selected_marker_ic")
        self.venueMapView.selectedMarker = selectedMarker
    }

    private func indexVisible() -> Int {
        guard let indexPathVisible = self.venueCollectionView.indexPathsForVisibleItems().first else {
            return -1
        }
        return indexPathVisible.row
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

//MARK:- Scroll View Delegate

extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let marker = self.markers[self.indexVisible()]
        self.setSelectedMarker(marker)
        self.resetMarkersIconWithout(marker)
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let marker = self.markers[self.indexVisible()]
        self.setSelectedMarker(marker)
        self.resetMarkersIconWithout(marker)
    }
}

//MARK:- Google Map Delegate

extension MapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        guard let markerMap: MarkerMap = self.markers.filter({ $0.position.latitude == marker.position.latitude && $0.position.longitude == marker.position.longitude }).first else {
            return false
        }
        self.setSelectedMarker(markerMap)
        resetMarkersIconWithout(markerMap)
        self.scrollToCellAtIndex(markerMap.tag)
        return true
    }
}
