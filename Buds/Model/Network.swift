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
    //Grab a connection to Realtime database
    static var ref = Database.database().reference()
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
        
        // Add the activity with the User's ID identifying it
        ref.child("activity").childByAutoId().setValue(activityDetails)
        
        return true
    }
    
    // Log In a User with Firebase Auth
    static func logIn(email: String, password: String) {
        
    }
    
    static func getProfilePicture(userID: String, complete: @escaping (UIImage) -> ()) {
        
        var profilePicture: UIImage?
        
        // Step 1: Get access to the user in RealtimeDatabase
        ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            
            // Step 2: Get that users Profile Picture URL
            let value = snapshot.value as? NSDictionary
            if let profilePictureURL = value?["profilePicture"] as? String {
                
                // Step 3: Get the picture from storage using that URL
                let storageRef = Storage.storage().reference(forURL: profilePictureURL)
                storageRef.getData(maxSize: 4*1024*1024, completion: { (data, error) in
                    
                    if let error = error {
                        print("There was an error getting the profile picture: \(error.localizedDescription)")
                        return
                    }
                    if let data = data {
                        // Step 4: Convert the Firebase Storage Data to an Image
                        profilePicture = UIImage(data: data)
                    }
                })
            } else {
                // The User doesn't have a profile picture
                // Return a default one
                profilePicture = UIImage(named: "person-icon")
            }
            //Step 5: Use the completion handler to return the Profile Picture
            complete(profilePicture!)
        }
    }
    

    
    
}
