//
//  FavouriteNewsViewModel.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 03.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation
import UIKit

protocol FavouriteNewsViewModelProtocol{
    var numberOfRowsInSection: Int { get }
    func articleForCellAt(indexPath: IndexPath) -> Article
    func deleteArticle(article: Article)
}

class FavouriteNewsViewModel: FavouriteNewsViewModelProtocol {
    private var getArticlesFromStorage: [Article] {
        let storage = Storage()
        let articles: [Article] = storage.cachedPlainObject()
        return articles
    }
    
    var numberOfRowsInSection : Int {
        return getArticlesFromStorage.count
    }
    
    func articleForCellAt(indexPath: IndexPath) -> Article {
        return getArticlesFromStorage[indexPath.row]
    }
    
    func deleteArticle(article: Article) {
        let storage = Storage()
        try? storage.delete(object: article)
    }
}

