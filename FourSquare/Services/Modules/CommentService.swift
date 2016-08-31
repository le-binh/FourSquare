//
//  CommentService.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/31/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift
import Alamofire

typealias CompletionPostCommentTip = (completion: Bool) -> Void

class CommentService {

    func commentTips(venueId: String, commentText: String, completion: CompletionPostCommentTip) {
        let commentPath = ApiPath.Comment.path
        guard let userToken = UserRealmManager.sharedInstance.getOauthToken() else {
            return
        }
        var parameters = JSObject()
        parameters["oauth_token"] = userToken.authToken
        parameters["v"] = APIKeys.VersionAPI
        parameters["venueId"] = venueId
        parameters["text"] = commentText
        Alamofire.request(.POST, commentPath, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .Success(_):
                let userTip = UserTip()
                guard let user = UserRealmManager.sharedInstance.getUser() else {
                    completion(completion: false)
                    return
                }
                userTip.avatar = user.avatar
                let venueTip = VenueTip()
                venueTip.userTip = userTip
                venueTip.comment = commentText
                venueTip.timeStamp = NSDate().timeIntervalSince1970
                UserRealmManager.sharedInstance.updateTips(venueId, tip: venueTip)
                completion(completion: true)
            case .Failure(_):
                completion(completion: false)
            }
        }

    }
}
