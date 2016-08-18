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

    func deleteWithoutFavoriteAndHistory() {
        do {
            let realm = try Realm()
            try realm.write({
                let venues = realm.objects(Venue).filter("isFavorite = false AND isHistory = false")
                realm.delete(venues)
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

    func addFavorite(venue: Venue) {
        do {
            let realm = try Realm()
            try realm.write({
                let venuesWillFavorite = realm.objects(Venue).filter("id = '\(venue.id)'")
                for element in venuesWillFavorite {
                    element.didFavorite = true
                }
                if let venueDidFavorite = realm.objects(Venue).filter("id = '\(venue.id)' AND isFavorite = true").first {
                    venueDidFavorite.historyTimestamp = NSDate()
                    return
                }
                realm.create(Venue.self, value: venue, update: false)
                if let newVenue = realm.objects(Venue).filter("id = '\(venue.id)'").last {
                    newVenue.isFavorite = true
                    newVenue.section = ""
                    newVenue.historyTimestamp = NSDate()
                } })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteFavorite(id: String) {
        do {
            let realm = try Realm()
            try realm.write({
                let venues = realm.objects(Venue).filter("id = '\(id)'")
                for element in venues {
                    element.didFavorite = false
                }
                if let venue = realm.objects(Venue).filter("id = '\(id)' AND isFavorite = true").first {
                    realm.delete(venue)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func addHistory(venue: Venue) {
        do {
            let realm = try Realm()
            try realm.write({
                if let venueHistory = realm.objects(Venue).filter("id = '\(venue.id)' AND isHistory = true").first {
                    venueHistory.historyTimestamp = NSDate()
                    return
                }
                let venues = realm.objects(Venue).filter("isHistory = true").sorted("historyTimestamp", ascending: false)
                if venues.count == 20 {
                    realm.delete(venues.last!)
                }
                realm.create(Venue.self, value: venue, update: false)
                if let newVenue = realm.objects(Venue).filter("id = '\(venue.id)'").last {
                    newVenue.isHistory = true
                    newVenue.section = ""
                    newVenue.historyTimestamp = NSDate()
                }
            })

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
