//
//  ViewModel.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 03.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation

protocol NewsViewModelProtocol {
    
    var newsIsLoading: ((Bool) -> ())? { get set }
    var numberOfRowsInSection: Int { get }
    func articleFor(index: Int) -> Article?
    func loadNews(completion: @escaping (Bool) -> ())
    func modifyStorage(article: Article, strategy: StorageStrategy)
    func checkArticleInStorage(article:Article) -> Bool
}

class NewsViewModel: NewsViewModelProtocol {
    var newsIsLoading: ((Bool) -> ())?
    private var news: [Article] = []
    var numberOfRowsInSection : Int {
        guard !news.isEmpty else {
            return 0
        }
        
        return news.count
    }
    
    func loadNews(completion: @escaping (Bool) -> ()) {
        newsIsLoading?(true)
        Networking.loadNews { [weak self] newspaper,isLoaded   in
            guard let self = self else { return }
            
            guard let newspaper = newspaper else {
                completion(false)
                return}
            self.news = Networking.extractNewsFromArray(news: newspaper)
            completion(true)
            self.newsIsLoading?(false)
        }
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
    
    func checkArticleInStorage(article:Article) -> Bool  {
           let storage = Storage()
           let articles: [Article] = storage.cachedPlainObject()
           
           for someArticle in articles {
               if article.title == someArticle.title {
                return true
               }
           }
        return false
    }
}
