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
    
    enum Effect: Decodable {
        
        case relaxed
        case dizzy
        case hungry
        case euphoric
        case happy
        case depression
        case insomnia
        case pain
        case stress
        case cramps
        case creative
        case energetic
        case talkative
        case nausea
        case headache
        case uplifted
        case tingly
        case paranoid
        case sleepy
        case fatigue
        case headaches
        case focused
        case anxious
        case giggle
        case aroused
        case inflammation
        case spasticity
        case seizures
    }
    
    enum Category: Decodable {
        case positive
        case negative
        case all
    }
}
//extension Strain.Category: CaseIterable {}
extension Strain.Effect: CaseIterable {}

extension Strain.Effect: RawRepresentable {
    
    var rawValue: RawValue {
        switch self {
          case .relaxed: return "Relaxed"
          case .dizzy: return "Dizzy"
          case .hungry: return "Hungry"
          case .happy: return "Happy"
        default: return "Effect"
        }
    }
    
    
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
            case "Relaxed": self = .relaxed
            case "Dizzy": self = .dizzy
            case "Hungry": self = .hungry
            case "Euphoric": self = .euphoric
            case "Happy": self = .happy
            case "Depression": self = .depression
            case "Insomnia": self = .insomnia
            case "Pain": self = .pain
            case "Stress": self = .stress
            case "Cramps": self = .cramps
            case "Creative": self = .creative
            case "Energetic": self = .energetic
            case "Talkative": self = .talkative
            case "Nausea": self = .nausea
            case "Headache": self = .headache
            case "Uplifted": self = .uplifted
            case "Tingly": self = .tingly
            case "Paranoid": self = .paranoid
            case "Sleepy": self = .sleepy
            case "Fatigue": self = .fatigue
            case "Headaches": self = .headaches
            case "Focused": self = .focused
            case "Anxious": self = .anxious
            case "Giggly": self = .giggle
            case "Aroused": self = .aroused
            case "Inflammation": self = .inflammation
            case "Spasticity": self = .spasticity
            case "Seizures": self = .seizures
        default: return nil
        }
    }
}

extension Strain.Category: RawRepresentable {

    var rawValue: RawValue {
        switch self {
          case .positive: return "Positive"
          case .negative: return "Negative"
          case .all: return "All"
        default: return "Category"
        }
    }

    typealias RawValue = String

    init?(rawValue: RawValue) {
        switch rawValue {
        case "Positive": self = .positive
        case "Negative": self = .negative
        case "All": self = .all
        default: return nil
        }
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

//extension Category {
//    static func categories() -> [Category] {
//        //return [Strain.Category.positive, Strain.Category.negative]
//    }
//}
