//
//  BudsBodyLabel.swift
//  Buds
//
//  Created by Collin Browse on 4/21/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsBodyLabel: UILabel {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    
    private func configure() {
        font = UIFont.systemFont(ofSize: 15, weight: .medium)
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
