//
//  WelcomeNavigationController.swift
//  Buds
//
//  Created by Collin Browse on 7/1/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


class WelcomeNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let welcomeVC = WelcomeVC()
        pushViewController(welcomeVC, animated: true)
        //UITabBar.appearance().tintColor = .systemGreen
        
    }
    
}
