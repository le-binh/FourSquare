//
//  VenueContact.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class VenueContact: Object, Mappable {
    dynamic var phone: String = ""
    dynamic var twitter: String = ""

    var venues = LinkingObjects(fromType: Venue.self, property: "contact")

    var contact: String {
        return phone.isEmpty ? twitter : phone
    }

    required convenience init?(_ map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        phone <- map["phone"]
        twitter <- map["twitter"]
    }
}
