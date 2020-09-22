//
//  FavouritesViewController.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 03.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import UIKit

class FavouritesViewController: BaseViewController{

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    var viewModel: FavouriteNewsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Favourite"
        view.backgroundColor = .white
        activityIndicator.hidesWhenStopped = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        navigationController?.navigationBar.barTintColor = .systemGray
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        
        let showNewsButton = UIBarButtonItem(
            title: "Show news",
            style: .plain,
            target: self,
            action: #selector(buttonPressed)
        )
        showNewsButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = showNewsButton
    }
    
    @objc func buttonPressed() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadData()
        
        guard viewModel.numberOfRowsInSection > 0
            else {
            showAlert(message: "No saved news")
            return
        }
        showAlert(message: "All news are shown")
        
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = Bundle.main.loadNibNamed("FavouriteNewsCell", owner: self, options: nil)?.first as? FavouriteNewsCell else {
                return UITableViewCell()
        }
        
        cell.removeFromStorage = { [weak self] in
            self?.deleteFromStorage(indexPath: indexPath)
        }
        
        cell.configureWith(article: viewModel.articleForCellAt(indexPath: indexPath))
        return cell
    }
    
    func deleteFromStorage(indexPath: IndexPath) {
        showDeleteAlert(message: "Delete selected news?") { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteArticle(article: self.viewModel.articleForCellAt(indexPath: indexPath))
            self.tableView.reloadData()
        }

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToDetailViewController(article: viewModel.articleForCellAt(indexPath: indexPath))
    }
}

