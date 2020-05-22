//
//  BudsIconsView.swift
//  Buds
//
//  Created by Collin Browse on 5/6/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


class BudsIconView: UIView {
    
    let symbolImageView = UIImageView()
    let textLabel = BudsSecondaryLabel(fontSize: 14, weight: .light)
    var width = 1.0

    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 1.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configure() {
        addSubviews(symbolImageView, textLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            //symbolImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -12),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            symbolImageView.widthAnchor.constraint(equalToConstant: 18),
            symbolImageView.heightAnchor.constraint(equalToConstant: 18),
            
            textLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 4),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    func setRating(withRating rating: String) {
        symbolImageView.image = SFSymbols.starIcon
        textLabel.text = rating
    }
    
    
    func setConsumptionIcon(withConsumptionMethod method: ConsumptionMethod) {
        self.width = 1.5
        
        switch method {
        case .joint:
            //symbolImageView.image = Icons.jointIcon
            textLabel.text = "Joint"
        case .blunt:
            //symbolImageView.image = Icons.jointIcon
            textLabel.text = "Blunt"
        case .bowl:
            //symbolImageView.image = Icons.bowlIcon
            textLabel.text = "Bowl"
        case .bong:
            //symbolImageView.image = Icons.bongIcon
            textLabel.text = "Bong"
        case .concentrate:
            //symbolImageView.image = Icons.concentrateIcon
            textLabel.text = "Concentrate"
        case .edible:
            //symbolImageView.image = Icons.edibleIcon
            textLabel.text = "Edible"
        case .vape:
            //symbolImageView.image = Icons.vapeIcon
            textLabel.text = "Vape"
        }
    }
    
    func setEffects(withEffects effects: [String]) {
        
        if !effects.isEmpty {
            self.width = 2.0
            var allEffects = ""
            for effect in effects {
                allEffects +=  ", " + effect
            }
            textLabel.text = allEffects[2...]
        }
    }
        
}
