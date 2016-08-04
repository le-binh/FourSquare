//
//  BaseService.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import Alamofire
import XCConsole

class BaseService {
    func request(method: METHOD, path: URLStringConvertible, parameters: JSObject? = nil, completion: Completion) {
        apiManager.request(method, path: path) { (result) in
            switch result {
            case .Success(let json):
                XCConsole.log(json)
                completion(result: Result.Success(json))
            case .Failure(let error):
                XCConsole.log(error.localizedDescription)
                completion(result: Result.Failure(error))
            }
        }
    }
}
