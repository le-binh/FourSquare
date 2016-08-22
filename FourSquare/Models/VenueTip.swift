//
//  VenueTip.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import RealmSwift

class VenueTip: Object, Mappable {
    dynamic var user: User?
    dynamic var comment: String = ""
    dynamic var timeStamp: Double = 0

    var venues = LinkingObjects(fromType: Venue.self, property: "tips")

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        user <- map["user"]
        comment <- map["text"]
        timeStamp <- map["createdAt"]
    }
}
