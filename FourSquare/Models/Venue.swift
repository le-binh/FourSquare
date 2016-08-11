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
    var venueId: String = ""
    var venueName: String = ""
    var venueRating: Float = 0.0
    var venueRatingColor: String = ""
    var venueVerified: Bool = true
    var venueWebsite: String = ""
    var venueThumbnail: Photo?
    var venueLocation: VenueLocation?
    var venueCategories: [VenueCategory] = []
    var venuePrice: VenuePrice?
    var venueContact: VenueContact?
    var venueHours: VenueHours?
    var venuePhotos: [Photo] = []
    var venueTips: [VenueTip] = []

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        venueId <- map["id"]
        venueName <- map["name"]
        venueRating <- map["rating"]
        venueRatingColor <- map["ratingColor"]
        venueVerified <- map["verified"]
        venueWebsite <- map["url"]
        venueThumbnail <- map["featuredPhotos.items.0"]
        venueLocation <- map["location"]
        venueCategories <- map["categories"]
        venuePrice <- map["price"]
        venueContact <- map["contact"]
    }
}
