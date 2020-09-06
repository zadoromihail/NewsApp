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
}
