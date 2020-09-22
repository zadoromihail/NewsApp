//
//  SearchNewsViewModel.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 04.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation
import UIKit

enum StorageStrategy {
    case delete
    case add
    
    var message: String {
        switch self {
        case .delete:
            return "Deleted from storage"
        case .add:
            return "Added to storage"
        }
    }
}

protocol SearchViewModelProtocol {
    var newsIsLoading: ((Bool) -> ())? { get set }
    var numberOfRowsInSection: Int { get }
    func articleFor(index: Int) -> Article?
    func modifyStorage(article: Article, strategy: StorageStrategy)
    func checkArticleInStorage(article:Article) -> Bool
    func searchNews( text: String, completion: @escaping (Bool, Int?) -> ())
    func currentArticle(indexPath: IndexPath) -> Article
}

class SearchViewModel: SearchViewModelProtocol {
    
    var newsIsLoading: ((Bool) -> ())?
    private var news: [Article] = []
    
    func searchNews(text: String, completion: @escaping (Bool, Int?) -> ()) {
        newsIsLoading?(true)
        Networking.searchNews(text: text) { [weak self] newspaper, isLoaded, numberOfnews in
            guard let self = self else { return }
            
            guard let newspaper = newspaper else {
                completion(false, nil)
                return}
            
            guard let numberOfnews = numberOfnews, numberOfnews > 0
                else {
                    completion(true, 0)
                    return
            }
            self.news = Networking.extractNewsFromArray(news: newspaper)
            completion(true, self.news.count)
            self.newsIsLoading?(false)
        }
    }
    
    var numberOfRowsInSection : Int {
        guard !news.isEmpty else {
            return 0
        }
        return news.count
    }
    
    func articleFor(index: Int) -> Article? {
        guard 0..<news.count ~= index else { return nil }
        return news[index]
    }
    
    func modifyStorage(article: Article, strategy: StorageStrategy) {
        let storage = Storage()
        switch strategy {
        case .add:
            try? storage.save(objetct: article)
        case .delete:
            try? storage.delete(object: article)
        }
    }
    
    func checkArticleInStorage(article: Article) -> Bool  {
        let storage = Storage()
        let articles: [Article] = storage.cachedPlainObject()
        let favourite = articles.first(where: { $0.title == article.title })
        return favourite != nil ? true : false
    }
    
    func currentArticle(indexPath: IndexPath) -> Article {
        let article = articleFor(index: indexPath.row)
        guard let safeArticle = article  else {
            return Article(source: nil, author: nil, title: nil, description: nil, url: nil, urlToImage: nil, publishedAt: nil, content: nil)
        }
        return safeArticle
    }
}
