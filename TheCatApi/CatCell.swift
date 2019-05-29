//
//  CatCell.swift
//  TheCatApi
//
//  Created by Mike Saradeth on 5/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class CatCell: UITableViewCell {
    static let cellIdentifier = "Cell"
    let favorite = UIImage(named: "favorite")
    let notFavorite = UIImage(named: "notFavorite")
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var favContainView: UIView!
    @IBOutlet weak var favoriteImage: UIImageView!
    var viewModelService: CatViewModelService?
    var index: Int!

    func configure(index: Int, item: Cat, viewModelService: CatViewModelService?) {
        self.index = index
        self.viewModelService = viewModelService
        
        //add favorite Tap Gesture and toggle logic
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        self.favContainView.addGestureRecognizer(tapGesture)
        
        // set favorite
        if let isFavorite = item.isFavorite {
            favoriteImage.image = isFavorite ? favorite : notFavorite
        }else {
            let isFavorite = viewModelService?.loadFavorite(index: index) ?? false
            favoriteImage.image = isFavorite ? favorite : notFavorite
        }

        // set cat image
        if let image = item.image {
            catImageView?.image = image
        }else {
            viewModelService?.loadImage(index: index, completion: { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.catImageView.image = image
                }
            })
        }
    }
    
    @objc func toggleFavorite() {
        let toggleFavorite = viewModelService?.toggleFavorite(index: index) ?? false
        favoriteImage.image = toggleFavorite ? favorite : notFavorite
    }
    
    deinit {
        print("deinit: CatCell")
    }
}
