//
//  NameTextField.swift
//  Buds
//
//  Created by Collin Browse on 6/24/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class BudsTextField: UITextField {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(placeholderText: String) {
        self.init(frame: .zero)
        placeholder = placeholderText
    }
    
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        borderStyle = .roundedRect
        layer.cornerRadius = 10
        clipsToBounds = true
        returnKeyType = .next
        autocorrectionType = .no
        autocapitalizationType = .none
        overrideUserInterfaceStyle = .light
    }
}
