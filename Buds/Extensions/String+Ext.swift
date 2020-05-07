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
}
