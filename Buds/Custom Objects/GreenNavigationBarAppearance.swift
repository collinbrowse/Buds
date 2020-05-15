//
//  GreenNavigationBarAppearance.swift
//  Buds
//
//  Created by Collin Browse on 5/15/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit

class GreenNavigationBarAppearance: UINavigationBarAppearance {

    
    override init(idiom: UIUserInterfaceIdiom) {
        super.init(idiom: idiom)
        configure()
    }
    
    override init(barAppearance: UIBarAppearance) {
        super.init(barAppearance: barAppearance)
        configure()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func configure() {
        titleTextAttributes = [.foregroundColor: UIColor.white]
        largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        configureWithOpaqueBackground()
        backgroundColor = .systemGreen
    }
}
