//
//  Network.swift
//  Buds
//
//  Created by Collin Browse on 7/15/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import Firebase

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
    static func addNewActivity(userID: String, activityDetails: [String : Any]) -> Bool {
        print("Add New Activity Function Called")
        
        //Grab a connection to Realtime database
        let ref = Database.database().reference()
        
        // Add the activity with the User's ID identifying it
        ref.child("activity").child(userID).child(getTodayString()).setValue(activityDetails)
        
        return true
    }
    
    // Helper Function to get the current Date/Time as a String
    static func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    
}
