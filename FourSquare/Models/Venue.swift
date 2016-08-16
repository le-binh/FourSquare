//
//  Venue.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/10/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Venue: Object, Mappable {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var rating: Double = 0.0
    dynamic var ratingColorString: String = ""
    dynamic var verified: Bool = true
    dynamic var website: String = ""
    dynamic var isFavorite: Bool = false
    dynamic var isHistory: Bool = false
    dynamic var section: String = ""
    dynamic var thumbnail: Photo?
    dynamic var location: VenueLocation?
    dynamic var price: VenuePrice?
    dynamic var contact: VenueContact?
    dynamic var hours: VenueHours?

    var categories = RealmSwift.List<VenueCategory>()
    var photos = RealmSwift.List<Photo>()
    var tips = RealmSwift.List<VenueTip>()

    required convenience init?(_ map: Map) {
        self.init()
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
        categories <- (map["categories"], CategoriesTransform())
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
