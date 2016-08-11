//
//  VenueContact.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class VenueContact: Mappable {
    var phone: String = ""
    var twitter: String = ""
    var contact: String {
        return phone.isEmpty ? twitter : phone
    }

    required init?(_ map: Map) {

    }
    func mapping(map: Map) {
        phone <- map["phone"]
        twitter <- map["twitter"]
    }
}
