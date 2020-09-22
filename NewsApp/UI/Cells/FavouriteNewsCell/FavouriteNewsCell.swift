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
    let maskLayer = CAGradientLayer()
    var removeFromStorage: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        configureMaskLayer()
        favouritesImageView.alpha = 0.25
        favouritesImageView.layer.cornerRadius = 20
        favouritesImageView.layer.masksToBounds = true
        favouritesImageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 2
        deleteFromFavourite.setImage(UIImage(named: "bin"), for: .normal)
        deleteFromFavourite.addTarget(self, action: #selector(deleteFrom), for: .touchUpInside)
        backgroundColor = .white
    }
    
    private func configureMaskLayer() {
        maskLayer.frame = favouritesImageView.bounds
        maskLayer.shadowRadius = 20
        maskLayer.shadowPath = CGPath(roundedRect: favouritesImageView.bounds.insetBy(dx: 30, dy: 50), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 1
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowColor = UIColor.white.cgColor
        favouritesImageView.layer.mask = maskLayer
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

