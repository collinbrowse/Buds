//
//  Constants.swift
//  Buds
//
//  Created by Collin Browse on 10/28/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit


enum TabBarIndices {
    static let ActivityFeedVC = 0
    static let SearchVC = 1
    static let FavoritesVC = 2
}

enum Images {
    
    static let defaultHeaderImageView = UIImage(named: "weed_background-2")
    static let emptyStateBackgroundImageView = UIImage(named: "cannabis_color_icon")
    static let avatarImageView = UIImage(named: "cadets_generic_avatar")
    static let avatarProfilePicture = UIImage(named: "person-icon")
    static let fullscreenBackgroundImage = UIImage(named: "weed_background")
}

enum Icons {
    
    static let defaultStrainIcon = UIImage(named: "cannabis_color_icon")
    static let defaultCannabisIcon = UIImage(named: "icons8-cannabis")
    static let jointIcon = UIImage(named: "icons8-joint-100")
    static let bluntIcon = UIImage(named: "icons8-joint-100")
    static let bowlIcon = UIImage(named: "cannabis-bowl-icon")
    static let bongIcon = UIImage(named: "icons8-bong-100")
    static let edibleIcon = UIImage(named: "icons8-cookie-100")
    static let concentrateIcon = UIImage(named: "cannabis_oil_icon")
    static let vapeIcon = UIImage(named: "vape_pen_icon")
    static let hashtagIcon = UIImage(named: "icons8-hashtag")
    static let exitIcon = UIImage(named: "icons8-exit")
}

enum SFSymbols {
    static let starIcon = UIImage(systemName: "star.fill")
    static let rightTriangle = UIImage(systemName: "arrowtriangle.right.fill")
    static let location = UIImage(systemName: "location")
}


enum LegalInfo {
    static let attributedString = NSMutableAttributedString(string: "By registering, you agree to our privacy policy. Icons by Icons8")
    static let privacyPolicyURL = URL(string: "https://www.collinbrowse.com/budsprivacypolicy.html")!
    static let icons8URL = URL(string: "https://icons8.com")!
}

enum RaceColors {
    static let hybrid = UIColor.systemGreen
    static let indica = UIColor.systemPurple
    static let sativa = UIColor.systemRed
}


enum TagTypes : CaseIterable {
    case rating, method, effect, location
    
    var value: String {
        switch self {
        case .rating:
            return "rating"
        case .method:
            return "method"
        case .effect:
            return "effects"
        case .location:
            return "location"
        }
    }
}


enum TagValues {
    static let ratings = ["⭐️5", "⭐️4", "⭐️3", "⭐️2", "⭐️1"]
    static let methods = ["Bowl", "Joint", "Vape", "Bong", "Blunt", "Concentrate", "Edible"]
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


enum FirebaseKeys {
    static let activity = "activity"
    static let users = "users"
    static let user = "user"
}


enum UserDefaultsKeys {
    static let hasLaunched = "isFirstLaunch"
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

