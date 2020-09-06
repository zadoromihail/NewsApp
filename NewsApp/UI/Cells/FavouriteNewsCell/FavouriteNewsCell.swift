//
//  FavouriteNewsCell.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 04.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import UIKit
import Kingfisher

class FavouriteNewsCell: UITableViewCell {

    @IBOutlet private weak var favouritesImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var deleteFromFavourite: UIButton!

    var removeFromStorage: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        favouritesImageView.alpha = 0.25
        favouritesImageView.layer.cornerRadius = 20
        favouritesImageView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.italicSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 2
               
        descriptionLabel.font = UIFont.italicSystemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 2
        
        deleteFromFavourite.setImage(UIImage(named: "bin"), for: .normal)
        deleteFromFavourite.addTarget(self, action: #selector(deleteFrom), for: .touchUpInside)
        
        backgroundColor = .white
    }

    @objc func deleteFrom() {
        removeFromStorage?()
    }
    
    func configureWith(article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        
        guard
            let urlString = article.urlToImage,
            let url = URL(string: urlString) else {
                favouritesImageView.image = UIImage(named: "news")?.withColor(.systemBlue)
            return
        }
        
        favouritesImageView.kf.setImage(with: url)
    }
}
