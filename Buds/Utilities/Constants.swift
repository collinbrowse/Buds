//
//  Constants.swift
//  Buds
//
//  Created by Collin Browse on 10/28/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit

enum Images {
    
    static let defaultHeaderImageView = UIImage(named: "background1")
}


enum StrainAPI {
    
    static let baseAPI = "http://strainapi.evanbusse.com"
    static let APIKey = "/3HT8al6"
    static let allStrains = "/strains/search/all"
    static let allEffects = "/searchdata/effects"
    static let allFlavors = "/searchdata/flavors"
    static let searchForStrainsByName = "/strains/search/name/"
    static let searchForStrainsByRace = "/strains/search/race/"
    static let searchForStrainsByEffect = "/strains/search/effect/"
    static let searchForStrainsByFlavor = "/strains/search/flavor/"
    static let searchForDescById = "/strains/data/desc/"
    static let searchForEffectById = "/strains/data/effects/"
    static let searchForFlavorById = "/strains/data/flavors/"
    
}


struct Constants {
    
    struct StrainAPI {
        static let APIKey = "3HT8al6"
    }
    
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
    
    enum Race: String, Decodable, CaseIterable {
        case all = "All"
        case indica = "Indica"
        case sativa = "Sativa"
        case hybrid = "Hybrid"
    }
    
    enum Category: String, Decodable, CaseIterable {
        case all = "All"
        case positive = "Positive"
        case negative = "Negative"
        case medical = "Medical"
    }
    
}



extension Constants {
    static func categories() -> [Category] {
        var array = [Category]()
        for category in Category.allCases {
            array.append(category)
        }
        return array
    }
    static func races() -> [Race] {
        var array = [Race]()
        for race in Race.allCases {
            array.append(race)
        }
        return array
    }
}



enum ScreenSize {
    
    static let width     = UIScreen.main.bounds.size.width
    static let height    = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
    
}


enum DeviceTypes {
    
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
    
}
