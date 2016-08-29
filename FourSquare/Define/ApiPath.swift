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
    static let userURL = "https://api.foursquare.com/v2/users/self"
    static let googleBaseURL = "https://maps.googleapis.com/maps/api"

    struct User: URLStringConvertible {
        static var path: String { return userURL }
        var URLString: String { return "" }
    }

    struct Explore: URLStringConvertible {
        static var path: String { return baseURL + "/explore" }
        var URLString: String { return "" }
    }

    struct Venue: URLStringConvertible {
        private let id: String
        init(id: String) {
            self.id = id
        }
        var photos: String { return baseURL + "/\(id)/photos" }
        var hours: String { return baseURL + "/\(id)/hours" }
        var tips: String { return baseURL + "/\(id)/tips" }
        var URLString: String { return baseURL + "/\(id)" }
    }

    struct Direction: URLStringConvertible {
        static var path: String { return googleBaseURL + "/directions/json" }
        var URLString: String { return "" }
    }
}
