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

    func getObject(id: String, section: String) -> Venue? {
        var result: Venue?
        do {
            let realm = try Realm()
            result = realm.objects(Venue).filter("id = '\(id)' AND section = '\(section)'").first
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return result
    }

    func updateVenueWithHours(id: String, section: String, hours: VenueHours) {
        do {
            let realm = try Realm()
            try realm.write({
                let venue = realm.objects(Venue).filter("id = '\(id)' AND section = '\(section)'").first
                venue?.hours = hours
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func updateVenueWithPhotos(id: String, section: String, photos: RealmSwift.List<Photo>) {
        do {
            let realm = try Realm()
            try realm.write({
                let venue = realm.objects(Venue).filter("id = '\(id)' AND section = '\(section)'").first
                venue?.photos.removeAll()
                venue?.photos.appendContentsOf(photos)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func updateVenueWithTips(id: String, section: String, tips: RealmSwift.List<VenueTip>) {
        do {
            let realm = try Realm()
            try realm.write({
                let venue = realm.objects(Venue).filter("id = '\(id)' AND section = '\(section)'").first
                venue?.tips.removeAll()
                venue?.tips.appendContentsOf(tips)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
