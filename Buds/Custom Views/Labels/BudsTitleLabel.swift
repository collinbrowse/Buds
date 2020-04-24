//
//  BudsTitleLabel.swift
//  Buds
//
//  Created by Collin Browse on 4/17/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsTitleLabel: UILabel {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.font = UIFont(name: "Arvo-Bold", size: fontSize)
        self.textAlignment = textAlignment
    }
    
    func configure() {
        textColor = .white
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
