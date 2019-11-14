//
//  Strain.swift
//  Buds
//
//  Created by Collin Browse on 11/7/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit

struct Strain: Decodable {
    
    let name: String
    let effect: Effect
    let category: Category
    
    enum Effect: String, Decodable, CaseIterable {
        
        case relaxed = "Relaxed"
        case dizzy = "Dizzy"
        case hungry = "Hungry"
        case euphoric = "Euphoric"
        case happy = "Happy"
        case depression = "Depression"
        case insomnia = "Insomnia"
        case pain = "Pain"
        case stress = "Stress"
        case cramps = "Cramps"
        case creative = "Creative"
        case energetic = "Energetic"
        case talkative = "Talkative"
        case nausea = "Nausea"
        case headache = "Headache"
        case uplifted = "Uplifted"
        case tingly = "Tingly"
        case paranoid = "Paranoid"
        case sleepy = "Sleepy"
        case fatigue = "Fatigue"
        case headaches = "Headaches"
        case focused = "Focused"
        case anxious = "Anxious"
        case giggle = "Giggle"
        case aroused = "Aroused"
        case inflammation = "Inflammation"
        case spasticity = "Spasticity"
        case seizures = "Seizures"
    }
    
    enum Category: String, Decodable, CaseIterable {
        case all = "All"
        case positive = "Positive"
        case negative = "Negative"
        case medical = "Medical"
    }
}

extension Strain {
  static func strains() -> [Strain] {
    guard
      let url = Bundle.main.url(forResource: "strains", withExtension: "json"),
      let data = try? Data(contentsOf: url)
      else {
        print("Error getting contents of JSON")
        return []
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode([Strain].self, from: data)
    } catch {
        print("Error decoding JSON")
      return []
    }
  }
}


extension Strain {
    static func categories() -> [Category] {
        var array = [Category]()
        for category in Category.allCases {
            array.append(category)
        }
        return array
    }
}


















//extension Strain.Effect: RawRepresentable {
//
//    var rawValue: RawValue {
//        switch self {
//          case .relaxed: return "Relaxed"
//          case .dizzy: return "Dizzy"
//          case .hungry: return "Hungry"
//          case .happy: return "Happy"
//        default: return "Effect"
//        }
//    }
//
//
//    typealias RawValue = String
//
//    init?(rawValue: RawValue) {
//        switch rawValue {
//            case "Relaxed": self = .relaxed
//            case "Dizzy": self = .dizzy
//            case "Hungry": self = .hungry
//            case "Euphoric": self = .euphoric
//            case "Happy": self = .happy
//            case "Depression": self = .depression
//            case "Insomnia": self = .insomnia
//            case "Pain": self = .pain
//            case "Stress": self = .stress
//            case "Cramps": self = .cramps
//            case "Creative": self = .creative
//            case "Energetic": self = .energetic
//            case "Talkative": self = .talkative
//            case "Nausea": self = .nausea
//            case "Headache": self = .headache
//            case "Uplifted": self = .uplifted
//            case "Tingly": self = .tingly
//            case "Paranoid": self = .paranoid
//            case "Sleepy": self = .sleepy
//            case "Fatigue": self = .fatigue
//            case "Headaches": self = .headaches
//            case "Focused": self = .focused
//            case "Anxious": self = .anxious
//            case "Giggly": self = .giggle
//            case "Aroused": self = .aroused
//            case "Inflammation": self = .inflammation
//            case "Spasticity": self = .spasticity
//            case "Seizures": self = .seizures
//        default: return nil
//        }
//    }
//}

//extension Strain.Category: RawRepresentable {
//
//    var rawValue: RawValue {
//        switch self {
//          case .positive: return "Positive"
//          case .negative: return "Negative"
//          case .all: return "All"
//        default: return "Category"
//        }
//    }
//
//    typealias RawValue = String
//
//    init?(rawValue: RawValue) {
//        switch rawValue {
//        case "Positive": self = .positive
//        case "Negative": self = .negative
//        case "All": self = .all
//        default: return nil
//        }
//    }
//}



//extension Category {
//    static func categories() -> [Category] {
//        //return [Strain.Category.positive, Strain.Category.negative]
//    }
//}
