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
import Alamofire
import SwiftyJSON


class Network {

    //Grab a connection to Realtime database
    static var ref = Database.database().reference()
    
    static let group = DispatchGroup()

    
    deinit {
        Network.ref.removeAllObservers()
    }
    
    static func addNewActivity(userID: String, activityDetails: [String : String]) -> Bool {
        
        // Add the activity with the User's ID identifying it
        ref.child("activity").childByAutoId().setValue(activityDetails)
        
        return true
    }
    
    // Log In a User with Firebase Auth
    static func logInUser(email: String, password: String, complete: @escaping (Person?) -> ()) {

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let error = error {
                // Indicates log in was not successful
                print("There was an error signing in the user: \(error.localizedDescription)")
                complete(nil)
                return
            }
            else if user != nil {
                
                guard let userID = Auth.auth().currentUser?.uid else {
                    fatalError("Unable To get the Current User's ID")
                }
                
                // Able to sign the user in, grab the rest of the info from Realtime Database
                Network.getUserInfo(userID: userID, complete: { userInfo in

                    let loggedInUser = Person(id: userID, name: userInfo["name"]!, email: userInfo["email"]!, location: userInfo["location"]!, birthday: userInfo["birthday"]!, profilePictureURL: userInfo["profilePictureURL"]!)
                    
                    complete(loggedInUser)
                })
            }
        }
    }
    
    static func logOutUser() {
        
        Switcher.setUserDefaultsIsSignIn(false)
        Switcher.removeUserDefaultsModelController()
    
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            Network.ref.child("activity").removeAllObservers()
            Network.ref.child("users").removeAllObservers()
            Switcher.updateRootViewController()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
        complete(profilePicture!)
    }
    
    ///getUserStrainData
    static func getUserStrainData(userID: String, complete: @escaping ([String: Array<String>]) -> ()) {
        
        ref.child("users").child(userID).child("strain_data").observeSingleEvent(of: .value) { (snapshot) in
            
            // value is now the data from firebase
            let value = snapshot.value as? NSDictionary
            
            // We are returning data
            var data = Dictionary<String, Array<String>>()
            
            // Should exit loop with blank dictionary if nothing is returned from firebase
            for (category, info) in value ?? NSDictionary() {
                let strains = info as? NSDictionary
                var strain = ""
                for (key, _) in strains ?? NSDictionary() {
                    strain = key as! String
                    // Need to check if the array has already been set up for that key
                    // If it has, we append to the array
                    // If not, set up the array
                    if (data["\(category)"] == nil) {
                        data["\(category)"] = []
                    }
                    data["\(category)"]!.append("\(strain)")
                }
            }
            complete(data)
        }
    }
    
    
    ///getStrainDetailsForUser
    static func getStrainDetailsForUser(userID: String, strain: String, complete: @escaping ([String: String]) -> ()) {
        
        ref.child("users").child(userID).child("strain").child(strain).observeSingleEvent(of: .value) { (snapshot) in
            
            // Retrieve the details that this user has for this strain
            let value = snapshot.value as? NSDictionary
            var data = Dictionary<String, String>()
            for (descriptionType, description) in value ?? NSDictionary() {
                data["\(descriptionType)"] = description as? String ?? ""
            }
            complete(data)
        }
    }
    
    
    ///displayActivityFeed
    static func displayActivityFeed(userID: String, complete: @escaping([ActivityModel]) -> ()) {
        
        var activities = [ActivityModel]()
        
        // Only display activity from that user
        ref.child("activity").queryOrdered(byChild: "user").queryEqual(toValue: userID).observe(.childAdded) { (snapshot) in

            if let dictionary = snapshot.value as? [String: Any] {
                
                // Here we are creating an arrary of ActivityModel Objects.
                // This is the best way to structure the information from firebase as we need
                // an array to populate the table view
                let activity = ActivityModel()
                
                activity.setValuesForKeys(dictionary)
                activities.insert(activity, at: 0)
            
                // Firebase has all the information besides the User's actual name. Let's add that as well
                self.ref.child("users").child(dictionary["user"] as! String).observeSingleEvent(of: .value) { (snapshot) in
                    
                    if let dict = snapshot.value as? [String: Any] {
                        activity.name = dict["name"] as? String
                        // Grab the URL of the Photo in Firebase Storage
                        activity.profilePictureURL = dict["profilePicture"] as? String
                    }
                    complete(activities)
                }
            }
        }
    }
    
   
    ///populateStrainInfo
    // This function will first call the Strain API to get all the effects that cannabis has
    // Once that is done, it will call Network.populateRandomEffects to get 5 strains for every cannabis effect
    static func populateStrainInfo() {
        
        Alamofire.request("http://strainapi.evanbusse.com/3HT8al6/searchdata/effects", method: .get).validate().responseJSON { (response) in
            
            if response.result.isSuccess {
                
                let responseJSON = JSON(response.result.value!)

                for item in responseJSON.arrayValue {

                    if item["type"].string != nil {
                        StrainTypes.allTypes.insert(item["type"].string!)
                    }
                    if item["effect"].string != nil && !item["effect"].string!.contains(" ") {
                        StrainEffects.allEffects.append(item["effect"].string!)
                        StrainEffects.effectsDict[item["effect"].string!] = []
                    }
                }

                // Now find all the strains for these effects
                //let effect = StrainEffects.allEffects[0]
                //let api_url = "http://strainapi.evanbusse.com/3HT8al6/strains/search/effect/\(effect)"
                //Network.populateRandomEffects(count: 0, effect: effect, api_url: api_url)
                Network.populateRandomEffects()
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    ///populateRandomEffects
    // This method calls the Strain api on each effect that the strain api has.
    // This is already populated in the Universal Constant StrainEffects.allEffects by the time we get here
    // After each call it takes only the first 5 strains that have that effect and
    // stores them in the Universal Constant StrainEffects.effectsDict
    static func populateRandomEffects() {
        
        func callAPI(effect: String) {
            
            let semaphore = DispatchSemaphore(value: 1)
            let queue = DispatchQueue.global()
            
            queue.async {
                
                semaphore.wait()

                Alamofire.request("http://strainapi.evanbusse.com/3HT8al6/strains/search/effect/\(effect)", method: .get).validate().responseJSON { (response) in
                    
                    if response.result.isSuccess {
                        let responseJSON = JSON(response.result.value!)
                        var tempArray = [String]()
                        for j in 0...4 {
                            tempArray.append(responseJSON[j]["name"].string!)
                        }
                        StrainEffects.effectsDict[effect] = tempArray
                    }
                    else {
                        print("Errors \(String(describing: response.result.error))")
                    }
                    print(effect)
                    semaphore.signal()
                }
            }
        }
        
        for i in 0...StrainEffects.allEffects.count-1 {
            callAPI(effect: StrainEffects.allEffects[i])
        }
        
    }
    

}
