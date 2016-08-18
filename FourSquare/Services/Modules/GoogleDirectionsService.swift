//
//  GoogleDirectionsService.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/18/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire

typealias GoogleCompletion = (encodedString: String) -> Void
class GoogleDirectionService {

    func addOverlayToMapView(currentLocationCoord: CLLocationCoordinate2D, venueLocationCoord: CLLocationCoordinate2D, completion: GoogleCompletion) {
        let path = ApiPath.Direction.path
        var parameters = JSObject()
        parameters["origin"] = "\(currentLocationCoord.latitude), \(currentLocationCoord.longitude)"
        parameters["destination"] = "\(venueLocationCoord.latitude), \(venueLocationCoord.longitude)"
        parameters["key"] = GoogleMapsKeys.goolgeMapsApiKey
        Alamofire.request(.GET, path, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .Success(let data):
                guard let json = data as? JSObject, routes = json["routes"] as? JSArray, overViewPolyline = routes[0]["overview_polyline"] as? JSObject, points = overViewPolyline["points"] as? String else {
                    completion(encodedString: "")
                    return
                }
                completion(encodedString: points)
            case .Failure(_):
                completion(encodedString: "")
            }
        }
    }

}
