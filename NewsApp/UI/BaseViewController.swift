//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 06.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showDeleteAlert(message: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(
        title: "Yes",
        style: .destructive) { (_) in
            completion()
        }
        
        let cancelAction = UIAlertAction(
            title: "No",
            style: .default,
            handler: nil
        )
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    func pushToDetailViewController(article: Article) {
        let article = article
        let vc =  DetailViewController()
        let vm = DetailViewModel()
        guard article.title != nil, article.title != "" else { return }
        guard article.description != nil, article.description != "" else { return }
        guard article.publishedAt != nil, article.publishedAt != "" else { return }
        guard article.urlToImage != nil, article.urlToImage != "" else { return }
        guard article.author != nil, article.author != "" else { return }
        
        let date = "Published at: \(String(describing: article.publishedAt!.dropLast(10)))"
        let author = "Author: \(String(describing: article.author!))"
        vm.author = author
        vm.date = date
        vm.title = String(describing: article.title!)
        vm.description = String(describing: article.description!)
        vm.stringUrl = String(describing: article.urlToImage!)
        vc.viewModel = vm
        navigationController?.pushViewController(vc, animated: true)
    }
}
