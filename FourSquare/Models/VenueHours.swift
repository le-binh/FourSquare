//
//  VenueHours.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class VenueHours: Object, Mappable {
    var timeFrames = RealmSwift.List<Hours>()

    var venues = LinkingObjects(fromType: Venue.self, property: "hours")

    required convenience init?(_ map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        timeFrames <- map["timeframes"]
    }
}

extension VenueHours {
    var timeToday: String {
        guard let hoursToday = timeFrames.first else {
            return Strings.NotAvailable
        }
        let openTime = formatTime(hoursToday.openTime)
        let closeTime = formatTime(hoursToday.closeTime)
        return openTime + "~" + closeTime
    }

    func formatTime(time: String) -> String {
        return time.insert(2, ":")
    }
}

class Hours: Object, Mappable {
    dynamic var openTime: String = ""
    dynamic var closeTime: String = ""

    var venueHours = LinkingObjects(fromType: VenueHours.self, property: "timeFrames")

    required convenience init?(_ map: Map) {
        self.init()
    }
    func mapping(map: Map) {
        openTime <- map["open.0.start"]
        closeTime <- map["open.1.end"]
    }
}
