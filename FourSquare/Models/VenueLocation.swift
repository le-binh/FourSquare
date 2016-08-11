//
//  LocationVenue.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/10/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class VenueLocation: Mappable {
    var latitude: Double = 0
    var longitude: Double = 0
    var distance: Int = 0
    var address: [String] = [""]
    var fullAddress: String {
        var result: String = ""
        for element in address {
            result = (element == address.last) ? result + element: result + "\(element),"
        }
        return result
    }

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        latitude <- map["lat"]
        longitude <- map["lng"]
        distance <- map["distance"]
        address <- map["formattedAddress"]
    }
}
