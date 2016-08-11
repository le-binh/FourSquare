//
//  VenueService.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/10/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

typealias VenuesCompletion = (venues: [Venue]) -> Void
class VenueService: BaseService {
    func loadVenues(latitude: Double, longtitude: Double, section: String, limit: Int, offset: Int, completion: VenuesCompletion?) {
        let path = ApiPath.Explore.path
        var parameters = JSObject()
        parameters["ll"] = "\(latitude),\(longtitude)"
        parameters["section"] = section
        parameters["limit"] = limit
        parameters["offset"] = offset
        request(.GET, path: path, parameters: parameters) { (result) in
            guard let json = result.value, groups = json["groups"] as? JSArray else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(venues: [])
                })
                return
            }
            var venues: [Venue] = []
            for group in groups {
                guard let items = group["items"] as? JSArray else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion?(venues: [])
                    })
                    return
                }
                let venuesInGroup = items.map({ Mapper<Venue>().map($0["venue"]) })
                venues.appendContentsOf(venuesInGroup)
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion?(venues: venues)
            })
        }
    }
}
