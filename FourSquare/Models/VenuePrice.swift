//
//  VenuePrice.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class VenuePrice: Object, Mappable {
    dynamic var tier: Int = 0
    dynamic var currency: String = "$"

    var venues = LinkingObjects(fromType: Venue.self, property: "price")

    required convenience init?(_ map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        tier <- map["tier"]
        currency <- map["currency"]
    }
    func showCurrency() -> String {
        var result = ""
        for _ in 0..<tier {
            result = result + currency
        }
        return result
    }
}
