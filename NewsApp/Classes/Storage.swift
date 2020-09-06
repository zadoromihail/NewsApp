//
//  Storage.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 04.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

extension Realm {
    static var instance: Realm {
        let configuration = Realm.Configuration(schemaVersion: 2)
        return try! Realm(configuration: configuration)
    }
}

class Storage {
    private var realmInstance: Realm {
        return Realm.instance
    }
    
    func cachedPlainObject<T: Translatable>() -> [T] {
        let realm = realmInstance
        let realmObjects = Array(realm.objects(T.ManagedObject.self))
        let translatedObjects = realmObjects.map { T(object: $0) }
        return translatedObjects
    }
    
    func save<T: Translatable>(objetct: T) throws {
        let realm = realmInstance
        let realmObject = objetct.toManagedObject()
        try realm.write {
            realm.add(realmObject, update: .modified)
        }
    }
    
    func delete<T: Translatable & AutoTranslatable>(object: T) throws {
        let realm = realmInstance
        guard let realmObject = realm.object(ofType: T.ManagedObject.self, forPrimaryKey: object.translatablePrimaryKey()) else { return }
        try realm.write {
            realm.delete(realmObject)
        }
    }
}
