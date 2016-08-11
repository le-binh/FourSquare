//
//  User.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Mappable {
    var avatar: Photo?
    required init?(_ map: Map) {

    }
    func mapping(map: Map) {
        avatar <- map["photo"]
    }
}
