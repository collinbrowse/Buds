//
//  BudsEmptySateView.swift
//  Buds
//
//  Created by Collin Browse on 5/1/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsEmptyStateView : UIView {
    
    let messageLabel = BudsStrainTitleLabel(textAlignment: .center, fontSize: 24)
    let backgroundImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureMessageLabel()
        //configureBackgroundImageView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    func configureMessageLabel() {
        
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel
        messageLabel.text = "Some text"
        addSubview(messageLabel)
        
        let padding : CGFloat = 12
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            messageLabel.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    
    func configureBackgroundImageView() {
        
        backgroundImageView.image = Images.emptyStateBackgroundImageView
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 150),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 150),
            backgroundImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ])
    }
    
    
    
    
    
    
    
    
    
}
