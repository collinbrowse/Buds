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
    case unableToGetStrain = "There wasn't any information provided by the API for this strain"
    case unableToAddActivity = "There was an error adding your activity. Please try again"
    case unableToGetAllStrains = "There was an error getting strain information. Please try again"
    case networkError = "There was a network error. Pleasure ensure a proper network connection and try again"
}
