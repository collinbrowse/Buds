//
//  BudsAvatarImageView.swift
//  Buds
//
//  Created by Collin Browse on 5/4/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsAvatarImageView : UIImageView {
    
    
    var placeholderImage = Images.avatarImageView
    let cache = NetworkManager.shared.imageCache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    
    func downloadImage(fromURL urlString: String) {
        
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] (image) in
            guard let self = self else { return }
            
            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
}
