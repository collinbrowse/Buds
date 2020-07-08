//
//  String+Ext.swift
//  Buds
//
//  Created by Collin Browse on 5/7/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import Foundation


extension String {
 
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    

    mutating func capitalizingFirstLetter() {
        self = self.capitalizeFirstLetter()
    }
    
    
    func getAcronymForStrain(separator: String = "") -> String {
        let acronyms = self.components(separatedBy: " ").map({
            if $0.first == "#" {
                return String(Array($0)[1])
            } else {
                return String($0.first!)
            }
        }).joined(separator: separator);
        return acronyms;
    }

    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
    
}
