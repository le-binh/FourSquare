//
//  NotificationCenter.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/3/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation

struct NotificationCenterKey {
    static let updateItemsMenu = "ChangeItem"
    static let changeToMapView = "ChangeToMapView"
    static let changeToTableView = "ChangeToTableView"
    static let changeToMapViewSearch = "ChangeToMapViewSearch"
    static let changeToTableViewSearch = "ChangeToTableViewSearch"
    static let loadVenue = "LoadVenue"
    static let scrollCollectionView = "ScrollCollectionView"
}
struct NotificationCenterUserInfo {
    static let menuItem = "item"
    static let indexCell = "index"
}
