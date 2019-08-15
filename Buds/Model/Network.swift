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

    static func addNewActivity(userID: String, activityDetails: [String : String]) -> Bool {
        
        // Add the activity with the User's ID identifying it
        ref.child("activity").childByAutoId().setValue(activityDetails)
        
        return true
    }
    
    // Log In a User with Firebase Auth
    static func logInUser(email: String, password: String, complete: @escaping (Person) -> ()) {

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                // Indicates log in was not successful
                print(error.localizedDescription)
            }
            else if user != nil {
                
                guard let userID = Auth.auth().currentUser?.uid else {
                    fatalError("Unable To get the Current User's ID")
                }
                
                // Able to sign the user in, grab the rest of the info from Realtime Database
                Network.getUserInfo(userID: userID, complete: { (userInfo) in
                
                    // First Grab the Profile Picture from FirebaseStorage
                    Network.getProfilePicture(userID: userID, complete: { (profilePicture) in
                        
                        // Finally create the Person Object
                        let loggedInUser = Person(id: userID, name: userInfo["name"]!, email: userInfo["email"]!, location: userInfo["location"]!, birthday: userInfo["birthday"]!, profilePictureURL: userInfo["profilePictureURL"]!, profilePicture: profilePicture)
                        
                        complete(loggedInUser)
                    })
                
                })
            }
        }
    }
    
    // Get a User's Info with Realtime Database
    private static func getUserInfo(userID: String, complete: @escaping ([String: String]) -> ()) {
        
        ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            var information = [String: String]()
            information["name"] = value?["name"] as? String ?? ""
            information["email"] = value?["email"] as? String ?? ""
            information["birthday"] = value?["birthday"] as? String ?? ""
            information["location"] = value?["location"] as? String ?? ""
            information["username"] = value?["username"] as? String ?? ""
            information["profilePictureURL"] = value?["profilePictureURL"] as? String ?? ""
            print("found the user's info in Realtime Database")
            complete(information)
        }
        
    }
    
    // Retrieves the User's profile picture with id: userID from FirebaseStorage
    // If none is available, then a default image is used
    static func getProfilePicture(userID: String, complete: @escaping (UIImage) -> ()) {

        var profilePicture = UIImage(named: "person-icon")
        
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
                        //Step 5: Use the completion handler to return the Profile Picture
                        complete(profilePicture!)
                    }
                })
            } else { // We didn't find that user
                complete(profilePicture!)
            }
        }
    }
}
