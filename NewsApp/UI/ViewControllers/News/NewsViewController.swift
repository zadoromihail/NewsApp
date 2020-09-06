//
//  NewsViewController.swift
//  
//
//  Created by Михаил Задорожный on 03.09.2020.
//

import UIKit
 
class NewsViewController: BaseViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: NewsViewModelProtocol!
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        connectionChecker()
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "News"
        
        activityIndicator.hidesWhenStopped = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNews), for: .valueChanged)
       
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .systemGray
      
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
    }
    
    @objc func loadNews() {
        connectionChecker()
        guard viewModel.numberOfRowsInSection > 0 else {
            return
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func connectionChecker() {
        guard CheckInternet.Connection() else {
            showAlert(message: "Internet is not connected")
            refreshControl.endRefreshing()
            return
        }
        
        viewModel.loadNews { [weak self] isLoaded in
            guard isLoaded else {
                self?.showAlert(message: "Download error")
                return
            }
        }
        refreshControl.endRefreshing()
    }
    
    private func bindUI() {
        viewModel.newsIsLoading = { [weak self] (isLoading) in
            guard let self = self else { return }
            if self.refreshControl.isRefreshing && isLoading {
                return
            }
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            guard !isLoading else { return }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

//MARK: -UITableViewDelegate
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
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
            self?.viewModel.modifyStorage(article: article, strategy: strategy)
            self?.showAlert(message: strategy.message)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
