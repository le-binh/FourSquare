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

class VenueTip: Mappable {
    var user: User?
    var comment: String = ""
    var timeStamp: Int = 0
    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        user <- map["user"]
        comment <- map["text"]
        timeStamp <- map["createdAt"]
    }
}
