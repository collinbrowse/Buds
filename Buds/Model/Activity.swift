//
//  Activity.swift
//  Buds
//
//  Created by Collin Browse on 5/5/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


enum ConsumptionMethod {
    case joint, blunt, bowl, bong, edible, concentrate, vape
}

@objcMembers
class Activity: NSObject {
    
    var location: String?
    var rating: String?
    var smoking_style: String?
    var strain: String?
    var time: String?
    var date: Date?
    var user: String?
    var name: String?
    var profilePictureURL: String?
    var note: String?
    var consumptionMethod: ConsumptionMethod?
}
