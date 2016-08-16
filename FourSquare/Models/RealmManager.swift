//
//  RealmManager.swift
//  FourSquare
//
//  Created by Mylo Ho on 8/16/16.
//  Copyright © 2016 Le Van Binh. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {

    static let sharedInstance = RealmManager()

    func addObject(object: Object) {
        do {
            let realm = try Realm()
            try realm.write({
                realm.add(object)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteAll() {
        do {
            let realm = try Realm()
            try realm.write({
                realm.deleteAll()
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteSection(section: String) {
        do {
            let realm = try Realm()
            try realm.write({
                let venues = realm.objects(Venue).filter("section = '\(section)'")
                realm.delete(venues)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
