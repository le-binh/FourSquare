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

class ListTransform<T: Object where T: Mappable>: TransformType {
    typealias Object = RealmSwift.List<T>
    typealias JSON = String

    func transformToJSON(value: Object?) -> JSON? {
        return "\(value)"
    }

    func transformFromJSON(value: AnyObject?) -> Object? {
        guard let items = value as? JSArray else {
            return nil
        }
        let result = RealmSwift.List<T>()
        for item in items {
            if let venueItem = Mapper<T>().map(item) {
                result.append(venueItem)
            }
        }
        return result
    }
}
