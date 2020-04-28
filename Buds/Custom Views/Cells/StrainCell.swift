//
//  StrainCell.swift
//  Buds
//
//  Created by Collin Browse on 4/24/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class StrainCell: UICollectionViewCell {
    
    static let reuseID = String(describing: StrainCell.self)
    
    let strainImageView = BudsStrainImageView(frame: .zero)
    let strainNameLabel = BudsTitleLabel(textAlignment: .center, fontSize: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(strain: Strain) {
        strainNameLabel.text = strain.name
        
        if      strain.race == "hybrid" { strainImageView.setBackgroundColor(with: .green) }
        else if strain.race == "indica" { strainImageView.setBackgroundColor(with: .magenta) }
        else if strain.race == "sativa" { strainImageView.setBackgroundColor(with: .cyan) }
    }
    
    private func configure() {
        addSubviews(strainImageView, strainNameLabel)
        
        let padding : CGFloat = 8
        
        NSLayoutConstraint.activate([
            strainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            strainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            strainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            strainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            strainNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            strainNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            strainNameLabel.leadingAnchor.constraint(equalTo: strainImageView.leadingAnchor, constant: padding),
            strainNameLabel.trailingAnchor.constraint(equalTo: strainImageView.trailingAnchor, constant: -padding)
        ])
    }
    
}
