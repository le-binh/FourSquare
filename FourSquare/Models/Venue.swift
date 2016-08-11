//
//  Venue.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/10/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class Venue: Mappable {
    var id: String = ""
    var name: String = ""
    var rating: Float = 0.0
    var ratingColor: String = ""
    var verified: Bool = true
    var website: String = ""
    var thumbnail: Photo?
    var location: VenueLocation?
    var categories: [VenueCategory] = []
    var price: VenuePrice?
    var contact: VenueContact?
    var hours: VenueHours?
    var photos: [Photo] = []
    var tips: [VenueTip] = []

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        rating <- map["rating"]
        ratingColor <- map["ratingColor"]
        verified <- map["verified"]
        website <- map["url"]
        thumbnail <- map["featuredPhotos.items.0"]
        location <- map["location"]
        categories <- map["categories"]
        price <- map["price"]
        contact <- map["contact"]
    }
}

extension Venue {
    var thumbnailPath: NSURL? {
        guard let prefix = thumbnail?.prefix, width = thumbnail?.width, height = thumbnail?.height, suffix = thumbnail?.suffix else {
            return nil
        }
        let path = prefix + String(width / 2) + "x" + String(height / 2) + suffix
        return NSURL(string: path)
    }
}
