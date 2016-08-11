//
//  VenueCategory.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class VenueCategory: Mappable {
    var categoryName: String = ""
    required init?(_ map: Map) {

    }
    func mapping(map: Map) {
        categoryName <- map["name"]
    }
}
