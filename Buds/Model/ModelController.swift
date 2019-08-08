//
//  App.swift
//  Buds
//
//  Created by Collin Browse on 8/7/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation

class ModelController {
    
    enum State {
        case unregistered
        case loggedIn
        case sessionExpired
    }
    
    var state: State = .unregistered
    
    var person: Person!
}
