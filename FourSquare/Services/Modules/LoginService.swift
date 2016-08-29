//
//  LoginService.swift
//  FourSquare
//
//  Created by Le Van Binh on 7/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import FSOAuth
import ObjectMapper
import RealmSwift

public typealias CompletionRequestUserInfo = (completion: Bool) -> Void

class LoginService: BaseService {

    func login() {
        FSOAuth.authorizeUserUsingClientId(APIKeys.ClientID, nativeURICallbackString: APIKeys.uriCallBack, universalURICallbackString: "", allowShowingAppStore: true)
    }

    func getAndSaveToken(accessCode: String, completionRequest: CompletionRequestUserInfo) {
        FSOAuth.requestAccessTokenForCode(accessCode, clientId: APIKeys.ClientID, callbackURIString: APIKeys.uriCallBack, clientSecret: APIKeys.ClientSecret) { (authToken, requestCompletion, errorCode) in
            if requestCompletion {
                if errorCode == .None {
                    let userToken = UserAuthToken()
                    userToken.authToken = authToken
                    UserRealmManager.sharedInstance.saveOauthToken(userToken)
                    self.loadUserInformation({ (completion) in
                        completionRequest(completion: completion)
                    })
                } else {
                    completionRequest(completion: false)
                }
            }
        }
    }

    func loadUserInformation(completion: CompletionRequestUserInfo) {
        let path = ApiPath.userURL
        let userToken = UserRealmManager.sharedInstance.getOauthToken()
        var parameters = JSObject()
        parameters["oauth_token"] = userToken?.authToken
        parameters["v"] = APIKeys.VersionAPI
        apiManager.request(.GET, path: path, parameters: parameters) { (result) in
            switch result {
            case .Success(let json):
                guard let userJSON = json["user"] as? JSObject else {
                    completion(completion: false)
                    return
                }
                guard let user = Mapper<User>().map(userJSON) else {
                    completion(completion: false)
                    return
                }
                UserRealmManager.sharedInstance.saveUser(user)
                completion(completion: true)
            case .Failure(_):
                completion(completion: false)
            }
        }
    }
}
