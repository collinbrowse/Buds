//
//  Network.swift
//  Buds
//
//  Created by Collin Browse on 7/15/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class Network {
    
    // Adds a smoking activity to Relatime Database
    // Data format:
    // activity
    // --user id
    // -- --Date/Time
    // -- -- --location
    // -- -- --rating
    // -- -- --smoking_style
    // -- -- --strain
    static func addNewActivity(userID: String, activityDetails: [String : String]) -> Bool {
        print("Add New Activity Function Called")
        
        //Grab a connection to Realtime database
        let ref = Database.database().reference()
        
        // Add the activity with the User's ID identifying it
        ref.child("activity").childByAutoId().setValue(activityDetails)
        
        return true
    }
    
    // Log In a User with Firebase Auth
    static func logIn(email: String, password: String) {
        
    }
    

    
    
}
