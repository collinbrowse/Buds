//
//  BirthdayModel.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation

struct Birthday {
    var month: String!
    var day: Int!
    var year: Int!
    
    init(month: String, day: Int, year: Int) {
        self.month = month
        self.day = day
        self.year = year
    }
}
