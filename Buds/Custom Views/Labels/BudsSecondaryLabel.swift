//
//  BudsSecondaryLabel.swift
//  Buds
//
//  Created by Collin Browse on 5/5/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsSecondaryLabel: UILabel {


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(fontSize: CGFloat, weight: UIFont.Weight) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    
    private func configure() {
        textColor = UIColor.secondaryLabel
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
