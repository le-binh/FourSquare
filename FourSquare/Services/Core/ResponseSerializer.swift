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
        //TODO:- Edit this validation code depending on response structure
        
        if let success = result["success"] as? Bool where success {
            guard let data = result["data"] as? JSObject else {
                return Result.Failure(Error.JSON)
            }
            return Result.Success(data)
        } else {
            guard let code = result["code"] as? Int, let data = result["data"] as? JSObject, let message = data["message"] as? String else {
                return Result.Failure(Error.JSON)
            }
            let error = Error.errorWithCode(code, description: message)
            return Result.Failure(error)
        }
    }
}
