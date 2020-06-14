//
//  PersistenceManager.swift
//  Buds
//
//  Created by Collin Browse on 6/10/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import Foundation


class PersistenceManager {

    
    static let shared = PersistenceManager()
    let defaults = UserDefaults.standard
    
    var appHasLaunchedBefore : Bool {
        return defaults.bool(forKey: UserDefaultsKeys.hasLaunched)
    }
    
    
    func didLaunch() {
        defaults.set(true, forKey: UserDefaultsKeys.hasLaunched)
    }
    
    
    func setLaunchStatus(status: Bool) {
        defaults.set(status, forKey: UserDefaultsKeys.hasLaunched)
    }
    
    
}
