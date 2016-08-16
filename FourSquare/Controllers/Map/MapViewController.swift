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

class MapViewController: ViewController {

    // MARK:- Properties

    @IBOutlet weak var venueMapView: GMSMapView!
    @IBOutlet weak var venueCollectionView: UICollectionView!
    @IBOutlet weak var backCollectionCellButton: UIButton!
    @IBOutlet weak var nextCollectionCellButton: UIButton!
    let collectionCellPadding: CGFloat = 10
    var indexMarker: Int = 0
    var markers: [MarkerMap] = []
    var venues: [Venue] = [] {
        didSet {
            self.clearMapData()
            self.addMultiMarker()
            self.venueCollectionView.reloadData()
        }
    }

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.configureGoogleMapsView()
    }

    // MARK:- Action

    @IBAction func backCollectionCellAction(sender: AnyObject) {
        let indexRow = self.visibleIndex() - 1
        if indexRow < 0 {
            return
        }
        self.scrollToCellAtIndex(indexRow, animated: true)
    }

    @IBAction func nextCollectionCellAction(sender: AnyObject) {
        let indexRow = self.visibleIndex() + 1
        if indexRow == self.venues.count {
            return
        }
        self.scrollToCellAtIndex(indexRow, animated: true)
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

    private func clearMapData() {
        self.venueMapView.clear()
        self.markers = []
    }

    private func sizeItemCellOfCollectionView() -> CGSize {
        let cellWidth = kScreenSize.width - 2 * self.collectionCellPadding
        let cellHeight = self.venueCollectionView.frame.height
        return CGSize(width: cellWidth, height: cellHeight)
    }

    private func scrollToCellAtIndex(index: Int, animated: Bool) {
        let indexPath: NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
        self.venueCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
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
            self.markers.append(marker)
            marker.map = self.venueMapView
            self.venueMapView.selectedMarker = marker
        } else {
            marker.icon = UIImage(named: "marker_ic")
            self.markers.append(marker)
            marker.map = self.venueMapView
        }
        self.indexMarker = self.indexMarker + 1
    }

    private func addMultiMarker() {
        self.indexMarker = 0
        for venue in self.venues {
            guard let latitude = venue.location?.latitude, longitude = venue.location?.longitude else {
                continue
            }
            addMarker(latitude, longitude)
            if self.indexMarker >= 10 {
                break
            }
        }
        let positionDefault = CLLocationCoordinate2DMake(CLLocationDegrees(16.0592007), CLLocationDegrees(108.1769168))
        let marker = (self.markers.count > 0) ? self.markers[0]: MarkerMap(position: positionDefault)
        self.venueMapView.camera = GMSCameraPosition(target: marker.position, zoom: marker.zoomLevelMarkers, bearing: 0, viewingAngle: 0)
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
        self.venueMapView.animateToLocation(selectedMarker.position)
    }

    private func visibleIndex() -> Int {
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
        return self.venues.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(VenueCollectionViewCell.self, forIndexPath: indexPath)
        let venue = self.venues[indexPath.row]
        cell.setUpData(venue)
        return cell
    }
}

//MARK:- Collection View Delegate

extension MapViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailVenueViewController = DetailVenueViewController.vc()
        let venue = self.venues[indexPath.row]
        detailVenueViewController.title = venue.name
        detailVenueViewController.venue = venue
        self.navigationController?.pushViewController(detailVenueViewController, animated: true)
    }
}

//MARK:- Scroll View Delegate

extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let marker = self.markers[self.visibleIndex()]
        self.setSelectedMarker(marker)
        self.resetMarkersIconWithout(marker)
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let marker = self.markers[self.visibleIndex()]
        self.setSelectedMarker(marker)
        self.venueMapView.animateToLocation(marker.position)
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
        self.venueMapView.animateToLocation(markerMap.position)
        resetMarkersIconWithout(markerMap)
        self.scrollToCellAtIndex(markerMap.tag, animated: false)
        return true
    }
}
