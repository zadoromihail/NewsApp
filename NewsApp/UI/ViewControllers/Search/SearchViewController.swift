//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 03.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: SearchViewModelProtocol!
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        guard CheckInternet.Connection() else {
             showAlert(message: "Internet is not connected")
            return
        }
    }
    
    private func setupUI() {
        title = "Search"
        view.backgroundColor = .white
        activityIndicator.hidesWhenStopped = true

        searchBar.delegate = self
        searchBar.placeholder = "Enter text (only English)"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barTintColor = .systemGray
        
        edgesForExtendedLayout = []
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(uploadNews), for: .valueChanged)
    }
    
    @objc func uploadNews() {
        guard !CheckInternet.Connection() else {
            searchNews()
            return
        }
        showAlert(message: "Internet is not connected")
        refreshControl.endRefreshing()
        scrollToTopIfNeeded()
    }
    
    @objc func searchNews() {
        refreshControl.endRefreshing()
        
        guard let query = searchBar.text, !query.isEmpty, CheckInternet.Connection() else {
            return
        }
        viewModel.searchNews(text: query) { [weak self] isLoaded, newsCount in
            guard let self = self else { return }
            guard let newsCount = newsCount else {
                self.showAlert(message: "Download error")
                return
            }
            guard isLoaded, newsCount > 0 else {
                self.showAlert(message: "No news")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollToTopIfNeeded()
            }
        }
    }
    
    private func scrollToTopIfNeeded() {
        guard viewModel.numberOfRowsInSection > 0 else {
            return
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
        sender.cancelsTouchesInView = false
    }
}

extension  SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = Bundle.main.loadNibNamed("NewsCell", owner: self, options: nil)?.first as? NewsCell,
            let article = viewModel.articleFor(index: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configureWith(article: article)
        cell.addToFavouritesAction = { [weak self] (strategy) in
            self?.showAlert(message: strategy.message)
            self?.viewModel.modifyStorage(article: article, strategy: strategy)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToDetailViewController(article: viewModel.currentArticle(indexPath:indexPath))
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard CheckInternet.Connection() else {
            showAlert(message: "Internet is not connected")
            return
        }
        searchNews()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchNews()
    }
}
