//
//  User.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/27/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class User: Object, Mappable {
    dynamic var id: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var avatar: Photo?

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        avatar <- map["photo"]
    }
}

// MARK:- User Extension

extension User {
    func getFullName() -> String {
        return "\(firstName), \(lastName)"
    }
}
