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
import RealmSwift

class MapViewController: ViewController {

    // MARK:- Properties

    @IBOutlet weak var venueMapView: GMSMapView!
    @IBOutlet weak var venueCollectionView: UICollectionView!
    @IBOutlet weak var backCollectionCellButton: UIButton!
    @IBOutlet weak var nextCollectionCellButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    let collectionCellPadding: CGFloat = 10
    let mapPadding: CGFloat = 30
    var indexMarker: Int = 0
    var markers: [MarkerMap] = []
    var venues: Results<Venue>! {
        didSet {
            if self.venues != nil && self.venues.count > 0 {
                self.clearMapData()
                self.addMultiMarker()
                self.venueCollectionView.reloadData()
                self.scrollToCellAtIndex(0, animated: false)
            }
            self.configureChangeCellButton()
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

    @IBAction func currentLocationAction(sender: AnyObject) {
        self.venueMapView.myLocationEnabled = true
        if let currentLocation = MyLocationManager.sharedInstanced.currentLocation {
            self.venueMapView.animateToLocation(currentLocation.coordinate)
        }
    }

    // MARK:- Private Functions

    private func configureCollectionView() {
        self.venueCollectionView.backgroundColor = UIColor.clearColor()
        self.venueCollectionView.delegate = self
        self.venueCollectionView.dataSource = self
        self.venueCollectionView.registerNib(VenueCollectionViewCell)
        self.configureCollectionViewFlowLayout()
        self.configureChangeCellButton()
    }

    private func configureCollectionViewFlowLayout() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .Horizontal
        collectionViewFlowLayout.minimumLineSpacing = 2 * self.collectionCellPadding
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: self.collectionCellPadding, bottom: 0, right: self.collectionCellPadding)
        collectionViewFlowLayout.itemSize = self.sizeItemCellOfCollectionView()
        self.venueCollectionView.collectionViewLayout = collectionViewFlowLayout
    }

    private func configureChangeCellButton() {
        if let venues = self.venues {
            self.backCollectionCellButton.hidden = venues.isEmpty
            self.nextCollectionCellButton.hidden = venues.isEmpty
        }
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
        let path = GMSMutablePath()
        for venue in self.venues {
            guard let latitude = venue.location?.latitude, longitude = venue.location?.longitude else {
                continue
            }
            addMarker(latitude, longitude)
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            path.addCoordinate(coordinate)
        }
        guard let currentLoction = MyLocationManager.sharedInstanced.currentLocation else {
            return
        }
        let positionDefault = currentLoction.coordinate
        let marker = (self.markers.count > 0) ? self.markers[0]: MarkerMap(position: positionDefault)
        self.venueMapView.camera = GMSCameraPosition(target: marker.position, zoom: marker.zoomLevelMarkers, bearing: 0, viewingAngle: 0)
        path.addCoordinate(positionDefault)
        let bounds: GMSCoordinateBounds = GMSCoordinateBounds(path: path)
        if path.count() == 1 {
            return
        }
        let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: mapPadding, left: mapPadding, bottom: 5 * mapPadding, right: mapPadding)
        self.venueMapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withEdgeInsets: edgeInsets))
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
        guard let venues = self.venues else {
            return 0
        }
        return venues.count
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
        detailVenueViewController.venue = venue
        self.navigationController?.pushViewController(detailVenueViewController, animated: true)
    }
}

//MARK:- Scroll View Delegate

extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = self.visibleIndex()
        if index >= self.markers.count {
            return
        }
        let marker = self.markers[self.visibleIndex()]
        self.setSelectedMarker(marker)
        self.resetMarkersIconWithout(marker)
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index = self.visibleIndex()
        if index >= self.markers.count {
            return
        }
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
