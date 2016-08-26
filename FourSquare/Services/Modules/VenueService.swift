//
//  VenueService.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/10/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

typealias VenuesCompletion = (venues: [Venue]) -> Void
typealias VenueHoursCompletion = (hours: VenueHours?) -> Void
typealias VenuePhotosCompletion = (photos: [Photo]) -> Void
typealias VenueTipsCompletion = (tips: [VenueTip]) -> Void
class VenueService: BaseService {

    func loadVenues(section: String, limit: Int, offset: Int, completion: VenuesCompletion?) {
        let path = ApiPath.Explore.path
        guard let currentLocation = MyLocationManager.sharedInstanced.currentLocation else {
            dispatch_async(dispatch_get_main_queue(), {
                completion?(venues: [])
            })
            return
        }
        var parameters = JSObject()
        parameters["venuePhotos"] = APIKeys.Thumbnail
        parameters["ll"] = "\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
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
            for group in groups {
                guard let items = group["items"] as? JSArray else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion?(venues: [])
                    })
                    return
                }
                for item in items {
                    if let venue = Mapper<Venue>().map(item["venue"]) {
                        venue.section = section
                        venue.availableTimestamp = NSDate()
                        RealmManager.sharedInstance.addVenue(venue)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion?(venues: [])
            })
        }
    }

    func loadVenueHours(id: String, section: String, completion: VenueHoursCompletion?) {
        let path = ApiPath.Venue.init(id: id).hours
        request(.GET, path: path) { (result) in
            guard let json = result.value, popular = json["popular"] as? JSObject else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(hours: nil)
                })
                return
            }
            let venueHours = Mapper<VenueHours>().map(popular)
            guard let hours = venueHours else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(hours: nil)
                })
                return
            }
            if hours.timeFrames.count == 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(hours: nil)
                })
                return
            }
            RealmManager.sharedInstance.updateVenueWithHours(id, section: section, hours: hours)
            dispatch_async(dispatch_get_main_queue(), {
                completion?(hours: nil)
            })
        }
    }

    func loadVenuePhotos(id: String, section: String, completion: VenuePhotosCompletion?) {
        let path = ApiPath.Venue(id: id).photos
        request(.GET, path: path) { (result) in
            guard let json = result.value, photos = json["photos"] as? JSObject, items = photos["items"] as? JSArray else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(photos: [])
                })
                return
            }
            let venuePhotos = RealmSwift.List<Photo>()
            for item in items {
                if let photo = Mapper<Photo>().map(item) {
                    venuePhotos.append(photo)
                }
            }
            RealmManager.sharedInstance.updateVenueWithPhotos(id, section: section, photos: venuePhotos)
            dispatch_async(dispatch_get_main_queue(), {
                completion?(photos: [])
            })
        }
    }

    func loadVenueTips(id: String, section: String, completion: VenueTipsCompletion?) {
        let path = ApiPath.Venue(id: id).tips
        request(.GET, path: path) { (result) in
            guard let json = result.value, tips = json["tips"] as? JSObject, items = tips["items"] as? JSArray else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(tips: [])
                })
                return
            }
            let venueTips = RealmSwift.List<VenueTip>()
            for item in items {
                if let tip = Mapper<VenueTip>().map(item) {
                    venueTips.append(tip)
                }
            }
            RealmManager.sharedInstance.updateVenueWithTips(id, section: section, tips: venueTips)
            dispatch_async(dispatch_get_main_queue(), {
                completion?(tips: [])
            })
        }
    }

    func searchVeues(near: String, query: String, completion: VenuesCompletion?) {
        let path = ApiPath.Explore.path
        var parameters = JSObject()
        parameters["venuePhotos"] = APIKeys.Thumbnail
        parameters["near"] = near
        parameters["query"] = query
        request(.GET, path: path, parameters: parameters) { (result) in
            guard let json = result.value, groups = json["groups"] as? JSArray else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(venues: [])
                })
                return
            }
            for group in groups {
                guard let items = group["items"] as? JSArray else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion?(venues: [])
                    })
                    return
                }
                for item in items {
                    if let venue = Mapper<Venue>().map(item["venue"]) {
                        venue.section = "search"
                        RealmManager.sharedInstance.addVenue(venue)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                completion?(venues: [])
            })
        }
    }
}
