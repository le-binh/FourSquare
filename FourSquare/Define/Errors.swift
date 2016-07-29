//
//  Error.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation

import Alamofire
import SwiftUtils

private enum ErrorType {
    case JSON
    var code: Int {
        switch self {
        case .JSON:
            return 600
        }
    }
    
    var description: String {
        switch self {
        case .JSON:
            return "JSON could not be serialized."
        }
    }
}

struct Error {
    private static func errorWithErrorType(errorType: ErrorType) -> NSError {
        return errorWithCode(errorType.code, description: errorType.description)
    }
    
    static func errorWithCode(code: Int, description: String) -> NSError {
        var userInfo = [NSObject : AnyObject]()
        userInfo[NSLocalizedDescriptionKey] = description
        return NSError(domain: ApiPath.baseURL, code: code, userInfo: userInfo)
    }
    
    static let JSON: NSError = {
        return Error.errorWithErrorType(.JSON)
    }()
}
