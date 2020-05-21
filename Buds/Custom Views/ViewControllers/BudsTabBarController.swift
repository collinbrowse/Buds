//
//  BudsTabBarController.swift
//  Buds
//
//  Created by Collin Browse on 5/21/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


class BudsTabBarController: UITabBarController {
    
    var modelController : ModelController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelController = Switcher.getUserDefaultsModelController()
        configureTabBarController()
    }
    
    
    func configureTabBarController() {
        
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createActivityFeedNavigationController(), createSearchNavigationController(), createFavoritesNavigationController()]
    }
    
    
    func createActivityFeedNavigationController() -> UINavigationController {
        
        let activityFeedVC = ActivityFeedVC()
        activityFeedVC.title = "Buds"
        activityFeedVC.modelController = modelController
        activityFeedVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        
        return UINavigationController(rootViewController: activityFeedVC)
    }
    
    
    func createSearchNavigationController() -> UINavigationController {
        
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.modelController = modelController
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createFavoritesNavigationController() -> UINavigationController {
        
        let favoritesVC = FavoritesVC()
        favoritesVC.title = "Favorites"
        favoritesVC.modelController = modelController
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        return UINavigationController(rootViewController: favoritesVC)
    }
}
