//
//  Translatable.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 04.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation
import RealmSwift

protocol Translatable {
    associatedtype ManagedObject: Object
    
    init(object: ManagedObject)
    func toManagedObject() -> ManagedObject
}

protocol AutoTranslatable {
    func translatablePrimaryKey() -> String
}
