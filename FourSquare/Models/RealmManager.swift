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
}
