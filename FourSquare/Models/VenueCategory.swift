//
//  VenueCategory.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class VenueCategory: Object, Mappable {
    dynamic var categoryName: String = ""

    var venues = LinkingObjects(fromType: Venue.self, property: "categories")

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        categoryName <- map["name"]
    }
}
