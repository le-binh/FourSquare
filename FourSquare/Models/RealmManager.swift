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

    func getVenuesBySection(section: SectionQuery) -> Results<Venue> {
        var result: Results<Venue>!
        do {
            let realm = try Realm()
            // print(Realm.Configuration.defaultConfiguration.fileURL)
            result = realm.objects(Venue).filter("section = '\(section.rawValue)' AND isClear = false").sorted("availableTimestamp", ascending: true)
        } catch {
            print("Realm Have Error!!")
        }
        return result
    }

    func getFavoriteVenues() -> Results<Venue> {
        var result: Results<Venue>!
        do {
            let realm = try Realm()
            result = realm.objects(Venue).filter("isFavorite = true").sorted("favoriteTimestamp", ascending: false)
        } catch {
            print("Realm Have Error!!")
        }
        return result
    }

    func getHistoryVenues() -> Results<Venue> {
        var result: Results<Venue>!
        do {
            let realm = try Realm()
            result = realm.objects(Venue).filter("isHistory = true").sorted("historyTimestamp", ascending: false)
        } catch {
            print("Realm Have Error!!")
        }
        return result
    }

    func getSearchVenues() -> Results<Venue> {
        var result: Results<Venue>!
        do {
            let realm = try Realm()
            result = realm.objects(Venue).filter("section = 'search' AND isClear = false")
        } catch {
            print("Realm Have Error!!")
        }
        return result
    }

    func addVenue(venue: Venue) {
        do {
            let realm = try Realm()
            try realm.write({
                if let oldVenue = realm.objects(Venue).filter("id = '\(venue.id)' AND section = '\(venue.section)'").first {
                    oldVenue.isClear = false
                    oldVenue.availableTimestamp = NSDate()
                    return
                }
                realm.add(venue)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteVenuesWithSectionSearch() {
        do {
            let realm = try Realm()
            try realm.write({
                let venues = realm.objects(Venue).filter("section = 'search'")
                realm.delete(venues)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteWithoutFavoriteAndHistory() {
        do {
            let realm = try Realm()
            try realm.write({
                let venuesWithFavoriteOrHistory = realm.objects(Venue).filter("isFavorite = true OR isHistory = true")
                for venue in venuesWithFavoriteOrHistory {
                    venue.isClear = true
                }
                let venues = realm.objects(Venue).filter("isFavorite = false AND isHistory = false")
                for venue in venues {
                    if let thumbnail = venue.thumbnail {
                        realm.delete(thumbnail)
                    }
                    if let location = venue.location {
                        realm.delete(location)
                    }
                    if let price = venue.price {
                        realm.delete(price)
                    }
                    if let contact = venue.contact {
                        realm.delete(contact)
                    }
                    if let hours = venue.hours {
                        realm.delete(hours)
                    }
                    realm.delete(venue.categories)
                    realm.delete(venue.photos)
                    for tip in venue.tips {
                        if let userTip = tip.userTip, avatar = userTip.avatar {
                            realm.delete(avatar)
                            realm.delete(userTip)
                        }
                        realm.delete(tip)
                    }
                    realm.delete(venue)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteDetailVenue(venue: Venue) {
        do {
            let realm = try Realm()
            try realm.write({
                realm.delete(venue.photos)
                for tip in venue.tips {
                    if let userTip = tip.userTip, avatar = userTip.avatar {
                        realm.delete(avatar)
                        realm.delete(userTip)
                    }
                    realm.delete(tip)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func clearSection(section: String) {
        do {
            let realm = try Realm()
            try realm.write({
                let venues = realm.objects(Venue).filter("section = '\(section.lowercaseString)'")
                for venue in venues {
                    venue.isClear = true
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func deleteSectionWithoutFavoriteAndHistory(section: String) {
        do {
            let realm = try Realm()
            try realm.write({
                let venuesSectionWithFavoriteOrHistory = realm.objects(Venue).filter("section = '\(section.lowercaseString)' AND (isFavorite = true OR isHistory = true)")
                for venue in venuesSectionWithFavoriteOrHistory {
                    venue.isClear = true
                }
                let venues = realm.objects(Venue).filter("section = '\(section.lowercaseString)' AND isFavorite = false AND isHistory = false")
                for venue in venues {
                    if let thumbnail = venue.thumbnail {
                        realm.delete(thumbnail)
                    }
                    if let location = venue.location {
                        realm.delete(location)
                    }
                    if let price = venue.price {
                        realm.delete(price)
                    }
                    if let contact = venue.contact {
                        realm.delete(contact)
                    }
                    if let hours = venue.hours {
                        realm.delete(hours)
                    }
                    realm.delete(venue.categories)
                    realm.delete(venue.photos)
                    realm.delete(venue.tips)
                    realm.delete(venue)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func getVenue(id: String, section: String) -> Venue? {
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
                    venueDidFavorite.favoriteTimestamp = NSDate()
                    return
                }
                if let venue = realm.objects(Venue).filter("id = '\(venue.id)' AND section = '\(venue.section)'").first {
                    venue.isFavorite = true
                    venue.favoriteTimestamp = NSDate()
                }
            })
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
                    venue.isFavorite = false
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
                    if let venue = venues.last {
                        realm.delete(venue)
                    }
                }
                if let venue = realm.objects(Venue).filter("id = '\(venue.id)' AND section = '\(venue.section)'").first {
                    venue.isHistory = true
                    venue.historyTimestamp = NSDate()
                }
            })

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
