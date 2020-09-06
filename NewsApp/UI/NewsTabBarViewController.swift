//
//  NewsTabBarViewController.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 04.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import Foundation
import UIKit


class NewsTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reloadTabs()
    }
    
    func reloadTabs() {
        viewControllers = [newsNC, fovouritesNC, searchNC]
    }
    private var newsNC: UINavigationController {
        let vc = NewsViewController()
        vc.viewModel = NewsViewModel()
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "list"), tag: 0)
        return nc
    }

    private var fovouritesNC: UINavigationController {
        let vc = FavouritesViewController()
        vc.viewModel = FavouriteNewsViewModel()
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(named: "bookmark.fill"), tag: 1)
        return nc
    }

    private var searchNC: UINavigationController {
        let vc = SearchViewController()
        vc.viewModel = SearchViewModel()
        let nc = UINavigationController(rootViewController: vc)
        nc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 2)
        return nc

    }
}
