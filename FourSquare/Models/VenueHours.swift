//
//  VenueHours.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class VenueHours: Mappable {
    var timeFrames: [Hours] = []
    required init?(_ map: Map) {

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

class Hours: Mappable {
    var openTime: String = ""
    var closeTime: String = ""
    required init?(_ map: Map) {

    }
    func mapping(map: Map) {
        openTime <- map["open.0.start"]
        closeTime <- map["open.1.end"]
    }
}
