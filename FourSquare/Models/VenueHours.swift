//
//  VenueHours.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class VenueHours: Mappable {
    var openTime: String = ""
    var closeTime: String = ""
    required init?(_ map: Map) {

    }
    func mapping(map: Map) {

    }
}
