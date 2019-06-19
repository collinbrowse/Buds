//
//  LocationModel.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation

struct Location {
    var city: String
    var state: String
    
    init(city: String, state: String) {
        self.city = city
        self.state = state
    }
}
