//
//  HeaderBackgroundImageView.swift
//  Buds
//
//  Created by Collin Browse on 4/17/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsHeaderImageView: UIImageView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(image: UIImage?) {
        super.init(frame: .zero)
        self.image = image
        translatesAutoresizingMaskIntoConstraints = false
    }
    

}
