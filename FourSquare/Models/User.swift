//
//  User.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class User: Object, Mappable {
    dynamic var avatar: Photo?

    var venueTips = LinkingObjects(fromType: VenueTip.self, property: "user")

    required convenience init?(_ map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        avatar <- map["photo"]
    }
}
