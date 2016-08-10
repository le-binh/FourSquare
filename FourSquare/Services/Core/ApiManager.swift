//
//  ApiManager.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import Alamofire

typealias Result = Alamofire.Result
typealias METHOD = Alamofire.Method

typealias JSObject = [String: AnyObject]
typealias JSArray = [JSObject]
typealias Completion = (result: Result <JSObject, NSError>) -> Void

let apiManager = ApiManager()

class ApiManager {
    private let manager = Manager.sharedInstance

    func logout() {
        reset()
    }

    func reset() {
        manager.session.cancelAllTalks()
    }

    func request(method: METHOD, path: URLStringConvertible, parameters: JSObject? = nil, completion: Completion) -> Request {
        let parameters = parameters ?? JSObject()
        let encoding: ParameterEncoding = (method == .GET ? .URL : .JSON)
        let request = Alamofire.request(method, path, parameters: parameters, encoding: encoding)
        request.response(completion)
        return request
    }
}

// MARK: -
extension NSURLSession {
    func cancelAllTalks(completion: (() -> Void)? = nil) {
        getTasksWithCompletionHandler { (tasks, uploads, downloads) -> Void in
            for task in tasks {
                task.cancel()
            }
            for task in uploads {
                task.cancel()
            }
            for task in downloads {
                task.cancel()
            }
            completion?()
        }
    }
}
