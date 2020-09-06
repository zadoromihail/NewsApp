//
//  CheckBox.swift
//  NewsApp
//
//  Created by Михаил Задорожный on 05.09.2020.
//  Copyright © 2020 Михаил Задорожный. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    let checkedImage = UIImage(named : "bookmarkFill")
    let uncheckedImage = UIImage(named : "bookmark")
    
    var isChecked = false {
        didSet {
            setImage(isChecked ? checkedImage : uncheckedImage, for: .normal)
        }
    }
}
