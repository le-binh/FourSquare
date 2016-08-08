//
//  ApiPath.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import Alamofire

struct ApiPath {
    static let baseURL = "https://api.foursquare.com/v2/venues"

    struct User: URLStringConvertible {
        private static var path: String { return baseURL + "/user" }
        static var login: String { return baseURL + "/login" }
        private let id: Int
        init(id: Int) {
            self.id = id
        }
        var URLString: String { return User.path + "/\(id)" }
    }
}
