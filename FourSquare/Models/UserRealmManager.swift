//
//  UserRealmManager.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/29/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealmManager {

    static let sharedInstance = UserRealmManager()

    func getOauthToken() -> UserOauthToken? {
        var token: UserOauthToken?
        do {
            let realm = try Realm()
            token = realm.objects(UserOauthToken).first
        } catch {
            print("Realm Have Error!!")
        }
        return token
    }

    func saveOauthToken(token: UserOauthToken) {
        do {
            let realm = try Realm()
            try realm.write({
                let oldToken = realm.objects(UserOauthToken).first
                if oldToken == nil {
                    realm.add(token)
                    return
                }
                if oldToken?.oauthToken == token.oauthToken {
                    return
                }
                realm.delete(realm.objects(UserOauthToken))
                realm.add(token)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteOauthToken() {
        do {
            let realm = try Realm()
            try realm.write({
                let oauthTokens = realm.objects(UserOauthToken)
                realm.delete(oauthTokens)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
