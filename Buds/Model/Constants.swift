//
//  Constants.swift
//  Buds
//
//  Created by Collin Browse on 10/28/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct StrainTypes {
        
        static let positiveEffect = "positive"
        static let negativeEffect = "negative"
        static let medicalEffect = "medical"

        static var allTypes = Set<String>()
    }

    struct StrainEffects {
        
        static let relaxed = "Relaxed"
        static let dizzy = "Dizzy"
        static let hungry = "Hungry"
        static let euphoric = "Euphoric"
        static let happy = "Happy"
        static let depression = "Depression"
        static let insomnia = "Insomnia"
        static let pain = "Pain"
        static let stress = "Stress"
        static let cramps = "Cramps"
        static let creative = "Creative"
        static let energetic = "Energetic"
        static let talkative = "Talkative"
        static let nausea = "Nausea"
        static let headache = "Headache"
        static let uplifted = "Uplifted"
        static let tingly = "Tingly"
        static let paranoid = "Paranoid"
        static let sleepy = "Sleepy"
        static let fatigue = "Fatigue"
        static let headaches = "Headaches"
        static let focused = "Focused"
        static let anxious = "Anxious"
        static let giggle = "Giggly"
        static let aroused = "Aroused"
        static let inflammation = "Inflammation"
        static let spasticity = "Spasticity"
        static let seizures = "Seizures"
        
        static var allEffects = [String]()
            
        static var effectsDict = [String: [String]]()
    }
    
    struct TableView {
        static let favoritesHeight = CGFloat(200.0)
        static let noDataHeight = CGFloat(100.0)
        static let rowHeight = CGFloat(120.0)
    }
}

