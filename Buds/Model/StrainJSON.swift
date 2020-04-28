//
//  StrainModel.swift
//  Buds
//
//  Created by Collin Browse on 11/20/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import SwiftyJSON


struct StrainModel : Hashable {
    
    var name: String
    var id: Int?
    var race: String?
    var flavors: [String]?
    var effects: Categories?
    
    struct Categories: Decodable, Hashable {
        var positive: [String]?
        var negative: [String]?
        var medical: [String]?
    }
}

struct StrainJSON: Decodable {
    
    var strain: [String: StrainDetails]
    
    struct StrainDetails: Decodable {
        
        var id: Int?
        var race: String?
        var flavors: [String]?
        var effects: Categories?
        
        struct Categories: Decodable {
            var positive: [String]?
            var negative: [String]?
            var medical: [String]?
        }
    }
    
    struct NameKey: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: NameKey.self)
        
        strain = [String: StrainDetails]()
        for key in container.allKeys {
            if let strainDetails = try? container.decode(StrainDetails.self, forKey: key) {
                strain[key.stringValue] = strainDetails
            }
        }
    }
}
