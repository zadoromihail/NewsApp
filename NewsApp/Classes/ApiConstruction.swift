//
//  ApiConstruction.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 03.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation
import RealmSwift

struct Newspaper: Decodable {
    let status : String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article : Decodable {
   var source: Source?
   var author : String?
   var title : String?
   var description: String?
   var url : String?
   var urlToImage : String?
   var publishedAt: String?
   var content : String?
    
    var isFavourite: Bool {
        let storage = Storage()
        let articles: [Article] = storage.cachedPlainObject()
        let favourite = articles.first(where: { $0.title == title })
        return favourite != nil ? true : false
    }
}

struct Source: Decodable {
    var id : String?
    var name : String?
}

extension Article: Translatable {
    init(object: _Article) {
        author = object.author
        title = object.title
        description = object.newsDescription
        url = object.url
        urlToImage = object.urlToImage
        publishedAt = object.publishedAt
        content = object.content
        
        guard let data = object.source else {
            source = nil
            return
        }
        source = Source(object: data)
    }
    
    func toManagedObject() -> _Article {
        let object = _Article()
        
        if let source = source {
            let _source = _Source()
            _source.id = source.id
            _source.name = source.name
            object.source = _source
        }
        
        object.author = author
        object.title = title
        object.newsDescription = description
        object.url = url
        object.urlToImage = urlToImage
        object.publishedAt = publishedAt
        object.content = content
        return object
    }
}

extension Article: AutoTranslatable {
    func translatablePrimaryKey() -> String {
        return title ?? ""
    }
}

@objcMembers
class _Article: Object {
    dynamic var source: _Source?
    dynamic var author: String?
    dynamic var title: String?
    dynamic var newsDescription: String?
    dynamic var url: String?
    dynamic var urlToImage: String?
    dynamic var publishedAt: String?
    dynamic var content : String?
    
    override static func primaryKey() -> String? {
        return "title"
    }
}

@objcMembers
class _Source: Object {
    dynamic var id : String?
    dynamic var name : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Source: Translatable {
    init(object: _Source) {
        id = object.id
        name = object.name
    }
    
    func toManagedObject() -> _Source {
        let object = _Source()
        object.id = id
        object.name = name
        return object
    }
}
