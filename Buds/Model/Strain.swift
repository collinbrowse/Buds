//
//  Strain.swift
//  Buds
//
//  Created by Collin Browse on 4/28/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import Foundation

struct Strain : Codable, Hashable {
    
    let id : Int
    let name : String
    let race : String
    let desc : String?
//    let effects : [String]?
//    let flavors : [String]?
}
