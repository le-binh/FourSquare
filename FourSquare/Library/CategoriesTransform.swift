//
//  CategoryTransform.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/16/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class CategoriesTransform: TransformType {
    typealias Object = RealmSwift.List<VenueCategory>
    typealias JSON = String

    func transformToJSON(value: Object?) -> JSON? {
        return "\(value)"
    }

    func transformFromJSON(value: AnyObject?) -> Object? {
        guard let categories = value as? JSArray else {
            return nil
        }
        let result = RealmSwift.List<VenueCategory>()
        for category in categories {
            if let venueCategory = Mapper<VenueCategory>().map(category) {
                result.append(venueCategory)
            }
        }
        return result
    }
}
