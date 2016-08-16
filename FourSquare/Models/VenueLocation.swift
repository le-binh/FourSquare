//
//  LocationVenue.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/10/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class VenueLocation: Object, Mappable {
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var distance: Int = 0
    dynamic var address: [String] = [""]

    var venues = LinkingObjects(fromType: Venue.self, property: "location")

    var fullAddress: String {
        var result: String = ""
        for element in address {
            result = (element == address.last) ? result + element: result + "\(element), "
        }
        return result
    }

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        latitude <- map["lat"]
        longitude <- map["lng"]
        distance <- map["distance"]
        address <- map["formattedAddress"]
    }
}
