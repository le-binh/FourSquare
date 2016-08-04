//
//  LoginService.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import XCConsole

class LoginService: BaseService {
    func login(username: String, password: String, completion: Completion?) {
        let path = ApiPath.User.login
        var parameters = JSObject()
        parameters["user_name"] = username
        parameters["password"] = password
        request(.POST, path: path, parameters: parameters) { (result) in
            // TODO:- Process the result

            dispatch_async(dispatch_get_main_queue()) {
                completion?(result: result)
            }
        }
    }
}
