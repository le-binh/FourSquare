//
//  ResponseSerializer.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    func response(completion: Completion) {
        responseJSON { (response) in
            let result = response.result
            if let error = result.error {
                completion(result: Result.Failure(error))
            } else if let json = result.value as? JSObject {
                completion(result: self.validateResult(json))
            } else {
                let error = Error.JSON
                completion(result: Result.Failure(error))
            }
        }
    }

    private func validateResult(result: JSObject) -> Result<JSObject, NSError> {
        // TODO:- Edit this validation code depending on response structure
        if let response = result["response"] as? JSObject {
            return Result.Success(response)
        } else {
            guard let meta = result["meta"] as? JSObject else {
                return Result.Failure(Error.JSON)
            }
            guard let code = meta["code"] as? Int, errorType = meta["errorType"] as? String, errorDetail = meta["errorDetail"] as? String else {
                return Result.Failure(Error.JSON)
            }
            let error = Error.errorWithCode(code, description: "\(errorType): \(errorDetail)")
            return Result.Failure(error)
        }
    }
}
