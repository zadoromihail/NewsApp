//
//  Networking.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 03.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    
    static let baseStringUrl = "http://newsapi.org/v2/everything?sortBy=popularity&apiKey=eed10d3d3d0e4c3b883799af349caada&pageSize=100&language=en&from=\(DateFormatter.lastWeekDate())&to=\(DateFormatter.yesterdayDate())"
    
    static let defaultUrl = URL(string: "\(baseStringUrl)&q=apple")
    
    static func customUrl(text: String) -> URL? {
        guard let url = URL(string: "\(baseStringUrl)" + "&q=\(text)")
            else { return nil }
        return url
    }
    
    static func searchNews(text: String, completion: @escaping (Newspaper?, Bool, Int?)->()) {
        let query = text.replacingOccurrences(of: " ", with: "+")
        let customUrl = Networking.customUrl(text: query)
        
        guard let url = customUrl else {
            let newspaper = Newspaper(
                status: nil,
                totalResults: nil,
                articles: [Article]()
            )
                completion(newspaper,true,0)
            return }
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            guard let data = responseData.data else {
                completion(nil,false,nil)
                return }
            
            do {
                let news = try JSONDecoder().decode(Newspaper.self, from: data)
                guard news.articles.count > 0
                else {
                    completion(news,true,news.articles.count)
                    return }
                
                completion(news,true,news.articles.count)
            }
                
            catch let error {
                print("Error\(error.localizedDescription)")
            }
        }
    }
    
    static func loadNews( completion: @escaping (Newspaper?, Bool)->() )  {
        AF.request(Networking.defaultUrl!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { responseData in
            guard let data = responseData.data else {
                completion( nil, false)
                return}
            do {
                let news = try JSONDecoder().decode(Newspaper.self, from: data)
                if news.articles.count > 0 {
                    completion(news,true)
                }
            }
            catch let error {
                print("Error\(error.localizedDescription)")
            }
        }
    }
    
    static func extractNewsFromArray(news: Newspaper) -> [Article] {
        let newspaper = news
        let articles = newspaper.articles
        return articles
    }
}
