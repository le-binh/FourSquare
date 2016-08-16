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
typealias VenueHoursCompletion = (hours: VenueHours?) -> Void
typealias VenuePhotosCompletion = (photos: [Photo]) -> Void
typealias VenueTipsCompletion = (tips: [VenueTip]) -> Void
class VenueService: BaseService {

    func loadVenues(latitude: Double, longtitude: Double, section: String, limit: Int, offset: Int, completion: VenuesCompletion?) {
        let path = ApiPath.Explore.path
        var parameters = JSObject()
        parameters["venuePhotos"] = APIKeys.Thumbnail
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

    func loadVenueHours(id: String, completion: VenueHoursCompletion?) {
        let path = ApiPath.Venue.init(id: id).hours
        request(.GET, path: path) { (result) in
            guard let json = result.value, popular = json["popular"] as? JSObject else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(hours: nil)
                })
                return
            }
            let venueHours = Mapper<VenueHours>().map(popular)
            if venueHours?.timeFrames.count == 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(hours: nil)
                })
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion?(hours: venueHours)
            })
        }
    }

    func loadVenuePhotos(id: String, completion: VenuePhotosCompletion?) {
        let path = ApiPath.Venue(id: id).photos
        request(.GET, path: path) { (result) in
            guard let json = result.value, photos = json["photos"] as? JSObject, items = photos["items"] as? JSArray else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(photos: [])
                })
                return
            }
            let venuePhotos = items.map({ Mapper<Photo>().map($0) })
            dispatch_async(dispatch_get_main_queue(), {
                completion?(photos: venuePhotos)
            })
        }
    }

    func loadVenueTips(id: String, completion: VenueTipsCompletion?) {
        let path = ApiPath.Venue(id: id).tips
        request(.GET, path: path) { (result) in
            guard let json = result.value, tips = json["tips"] as? JSObject, items = tips["items"] as? JSArray else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(tips: [])
                })
                return
            }
            let venueTips = items.map({ Mapper<VenueTip>().map($0) })
            dispatch_async(dispatch_get_main_queue(), {
                completion?(tips: venueTips)
            })
        }
    }
}
