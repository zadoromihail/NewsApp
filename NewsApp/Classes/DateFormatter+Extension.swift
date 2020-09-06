//
//  DateFormatter+Extension.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 06.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation

extension DateFormatter {
    static func yesterdayDate() -> String {
        let date = Date(timeInterval: -86400, since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.string(from: date)
        return String(dateString.dropLast(14))
    }
    
    static func lastWeekDate() -> String {
        let date = Date(timeInterval: -86400 * 7, since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.string(from: date)
        return String(dateString.dropLast(14))
    }
}
