//
//  Activity.swift
//  Buds
//
//  Created by Collin Browse on 5/5/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


enum ConsumptionMethod: String, Decodable {
    
    case joint = "Joint",
        blunt = "Blunt",
        bowl = "Bowl",
        bong = "Bong",
        edible = "Edible",
        concentrate = "Concentrate",
        vape = "Vape"
}

@objcMembers
class Activity: NSObject, Decodable {
    
    var user: String?
    var strain: String!
    var race: String?
    var note: String?
    var rating: Int!
    var consumptionMethod: ConsumptionMethod?
    var effects: [String]!
    var location: String!
    var brand: String?
    var time: String!
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case user, strain, race, note, rating, effects, location, brand, time, consumptionMethod = "smoking_style"
    }
    
}
