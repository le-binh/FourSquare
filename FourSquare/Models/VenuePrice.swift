//
//  VenuePrice.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class VenuePrice: Mappable {
    var tier: Int = 0
    var currency: String = "$"
    required init?(_ map: Map) {

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
