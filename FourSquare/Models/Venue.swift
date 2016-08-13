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
    var rating: Double = 0.0
    var ratingColorString: String = ""
    var verified: Bool = true
    var website: String = ""
    var isFavorite: Bool = false
    var isHistory: Bool = false
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
        ratingColorString <- map["ratingColor"]
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
    var ratingColor: UIColor {
        return UIColor.hexToColor(self.ratingColorString)
    }
    var showCategories: String {
        var result = ""
        for (index, category) in categories.enumerate() {
            result = (index == categories.count - 1) ? result + category.categoryName: result + "\(category.categoryName), "
        }
        return result
    }
}
