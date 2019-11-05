//
//  UserDefaultsHelper.swift
//  Buds
//
//  Created by Collin Browse on 11/4/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit


class UserDefaultsHelper {
    
    
    static func saveDictionary(dict: Dictionary<String, [String]>, key: String){
        let preferences = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: dict)
        preferences.set(encodedData, forKey: key)
        // Checking the preference is saved or not
        //didSave(preferences: preferences)
    }
    
    static func getDictionary(key: String) -> Dictionary<Int, String> {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: key) != nil{
            let decoded = preferences.object(forKey: key)  as! Data
            let decodedDict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Dictionary<Int, String>
            
            return decodedDict
        } else {
            let emptyDict = Dictionary<Int, String>()
            return emptyDict
        }
    }
    
    
    
}
