//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 17.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    var viewModel: DetailViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI(){
        title = "Details"
        view.backgroundColor = .white
        titleLabel.text = viewModel.title
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        descriptionLabel.text = viewModel.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .black
        dateLabel.text = viewModel.date
        dateLabel.numberOfLines = 0
        dateLabel.textColor = .black
        authorLabel.text = viewModel.author
        authorLabel.numberOfLines = 0
        authorLabel.textColor = .black
        imageView.kf.setImage(with: URL(string: viewModel.stringUrl))
        imageView.contentMode = .scaleAspectFit
    }
}
