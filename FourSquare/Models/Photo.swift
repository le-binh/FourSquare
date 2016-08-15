//
//  VenueThumbnail.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/11/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo: Mappable {
    var prefix: String = ""
    var suffix: String = ""
    var width: Int = 0
    var height: Int = 0
    required init?(_ map: Map) {

    }
    func mapping(map: Map) {
        prefix <- map["prefix"]
        suffix <- map["suffix"]
        width <- map["width"]
        height <- map["height"]
    }
}

extension Photo {
    var avatarPath: NSURL? {
        width = 70
        height = 70
        let path = prefix + "\(width)" + "x" + "\(height)" + suffix
        return NSURL(string: path)
    }
    var thumbnailPath: NSURL? {
        let path = prefix + "\(width / 2)" + "x" + "\(height / 2)" + suffix
        return NSURL(string: path)
    }
    var photoPathString: String {
        return prefix + "\(width)" + "x" + "\(height)" + suffix
    }
}
