//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 17.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation

protocol DetailViewModelProtocol{
    var title: String { get }
    var description: String { get }
    var date: String { get }
    var stringUrl: String { get }
    var author: String { get }
}

class DetailViewModel: DetailViewModelProtocol {
    var author: String = ""
    var title: String = ""
    var description: String = ""
    var date: String = ""
    var stringUrl: String = ""
}
