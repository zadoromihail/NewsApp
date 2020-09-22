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
        delegate = self
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

extension NewsTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view else {
            return false
        }
        if fromView != toView {
            UIView.transition(
                from: fromView,
                to: toView,
                duration: 0.3,
                options: [.transitionCrossDissolve],
                completion: nil
            )
        }
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let timeInterval: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(
            duration: timeInterval,
            dampingRatio: 1
        ) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}
