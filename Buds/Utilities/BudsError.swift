//
//  BudsError.swift
//  Buds
//
//  Created by Collin Browse on 5/14/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import Foundation

enum BudsError: String, Error {
    
    case noLocationStored = "There is no CLPlacemark Object stored for the users location"
    case unableToReverseGeocode = "There was an error trying to get your location, please ensure your network connection is active"
}
