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

    func getOauthToken() -> UserAuthToken? {
        var token: UserAuthToken?
        do {
            let realm = try Realm()
            token = realm.objects(UserAuthToken).first
        } catch {
            print("Realm Have Error!!")
        }
        return token
    }

    func saveOauthToken(token: UserAuthToken) {
        do {
            let realm = try Realm()
            try realm.write({
                let oldToken = realm.objects(UserAuthToken).first
                if oldToken == nil {
                    realm.add(token)
                    return
                }
                if oldToken?.authToken == token.authToken {
                    return
                }
                realm.delete(realm.objects(UserAuthToken))
                realm.add(token)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteUser() {
        do {
            let realm = try Realm()
            try realm.write({
                let oauthTokens = realm.objects(UserAuthToken)
                realm.delete(oauthTokens)
                let users = realm.objects(User)
                realm.delete(users)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func getUser() -> User? {
        var user: User?
        do {
            let realm = try Realm()
            user = realm.objects(User).first
        } catch {
            print("Realm Have Error!!")
        }
        return user
    }

    func saveUser(user: User) {
        do {
            let realm = try Realm()
            try realm.write({
                let oldUser = realm.objects(User).first
                if oldUser == nil {
                    realm.add(user)
                    return
                }
                if oldUser?.id == user.id {
                    return
                }
                realm.delete(realm.objects(User))
                realm.add(user)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
