//
//  NewsCell.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 03.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class NewsCell: UITableViewCell {
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var favouriteButton: CheckBox!
    
    var addToFavouritesAction: ((StorageStrategy) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.italicSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        descriptionLabel.font = UIFont.italicSystemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .black
        
        dateLabel.font = UIFont.italicSystemFont(ofSize: 15)
        dateLabel.textColor = .black
        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.backgroundColor = .lightGray
        
        favouriteButton.titleLabel?.textColor = .white
        favouriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        backgroundColor = .white
    }
    
    @objc func buttonPressed() {
        favouriteButton.isChecked = !favouriteButton.isChecked
        let strategy: StorageStrategy = favouriteButton.isChecked ? .add : .delete
        addToFavouritesAction?(strategy)
    }
    
    func configureWith(article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        favouriteButton.isChecked = article.isFavourite

        if let published = article.publishedAt?.dropLast(10) {
            dateLabel.text = "Published \( published)"
        }
        
        guard let urlString = article.urlToImage,let url = URL(string: urlString) else {
            newsImageView.isHidden = true
            return
        }
        
        newsImageView.kf.setImage(with: url)
    }
}
