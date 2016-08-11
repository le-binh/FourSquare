//
//  VenueService.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/10/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation

class VenueService: BaseService {
    func loadVenues(latitude: Double, longtitude: Double, section: String, limit: Int, offset: Int, completion: Completion?) {
        let path = ApiPath.Explore.path
        var parameters = JSObject()
        parameters["ll"] = "\(latitude),\(longtitude)"
        parameters["section"] = section
        parameters["limit"] = limit
        parameters["offset"] = offset
        request(.GET, path: path, parameters: parameters) { (result) in
            print(result.value)
            dispatch_async(dispatch_get_main_queue(), {
                completion?(result: result)
            })

        }
    }
}
