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
    static let defaults = UserDefaults.standard
    static let group = DispatchGroup()

    
    deinit {
        Network.ref.removeAllObservers()
    }
    
    /// Stores a dictionary in Firebase based on userID. This is added as an activity in Firebase and has the userID to uniquely identify it
    static func addNewActivity(userID: String, activityDetails: [String : Any], complete: @escaping (BudsError?) -> ()) {
        
        // Add the activity with the User's ID identifying it
        //ref.child("activity").childByAutoId().setValue(activityDetails)
        ref.child(FirebaseKeys.activity).childByAutoId().setValue(activityDetails) { (error, ref) in
            if error == nil {
                complete(nil)
            } else {
                complete(.unableToAddActivity)
            }
        }
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
            Network.ref.child(FirebaseKeys.activity).removeAllObservers()
            Network.ref.child(FirebaseKeys.users).removeAllObservers()
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "welcomeNavigationController") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = welcomeViewController
            appDelegate.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    // Get a User's Info with Realtime Database
    private static func getUserInfo(userID: String, complete: @escaping ([String: String]) -> ()) {
        
        ref.child(FirebaseKeys.users).child(userID).observeSingleEvent(of: .value) { (snapshot) in
            
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

        var profilePicture = Images.avatarProfilePicture
        
        // Step 1: Get access to the user in RealtimeDatabase
        ref.child(FirebaseKeys.users).child(userID).observeSingleEvent(of: .value) { (snapshot) in
            
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
    
    
    ///displayActivityFeed
    static func displayActivityFeed(userID: String, complete: @escaping(Swift.Result<[Activity], BudsError>) -> ()) {
        
        
        ref.child(FirebaseKeys.activity).queryOrdered(byChild: FirebaseKeys.user).queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                if let dictionary = snapshot.value as? [String: [String: Any]] {
                    
                    var activities = [Activity]()
                    
                    for firActivity in dictionary.values {
                        let activity = Activity()
                        activity.user = firActivity["user"] as? String
                        activity.strain = firActivity["strain"] as? String
                        activity.smoking_style = firActivity["smoking_style"] as? String
                        activity.rating = firActivity["rating"] as? Int
                        activity.note = firActivity["note"] as? String
                        activity.effects = firActivity["effects"] as? [String]
                        activity.location = firActivity["location"] as? String
                        activity.date = TimeHelper.getDateFromString(dateString: firActivity["time"] as! String)
                        activity.consumptionMethod = self.parseConsumptionMethod(method: firActivity["smoking_style"] as! String)
                        activities.insert(activity, at: 0)
                    }
                    activities = activities.sorted(by: {
                        $0.date!.compare($1.date!) == .orderedDescending
                    })
                    complete(.success(activities))
                }
            } else {
                complete(.failure(BudsError.noActivities))
            }
        }) { (error) in
            complete(.failure(BudsError(rawValue: error.localizedDescription)!))
        }
    }
    
    
    private static func parseConsumptionMethod(method: String) -> ConsumptionMethod {
        if method == "Bowl" {
            return .bowl
        } else if method == "Joint" {
            return .joint
        } else if method == "Vape" {
            return .vape
        } else if method == "Bong" {
            return .bong
        } else if method == "Blunt" {
            return .blunt
        } else if method == "Concentrate" {
            return .concentrate
        } else {
            return .edible
        }
    }
    
    
    static func getEffectsFromAPI(complete: @escaping([[String: String]]?) ->  ())  {
        
        let requestURL = StrainAPI.baseAPI + StrainAPI.APIKey + StrainAPI.allEffects
        Alamofire.request(requestURL).validate().responseJSON { (response) in
            
            var effectsDict = [[String: String]]()
            if response.result.isSuccess {
                
                let responseJSON = JSON(response.result.value!)
                
                for item in responseJSON.arrayValue {
                    if item["type"].string != nil && item["effect"].string != nil {
                        effectsDict.append([item["effect"].string! : item["type"].string!])
                    }
                }
                defaults.set(effectsDict, forKey: "effects")
                complete(effectsDict)
            } else {
                complete(nil)
            }
        }
    }
    
    
    /// Returns a complete dictionary of all strains accessible to the application. Strain data could come from either User Defaults or a network call to the Strain API.
    /// This function returns a lot of data and if using the API can take a while to return
    static func getAllStrains(complete: @escaping(Swift.Result<JSON, BudsError>) -> ()) {

        if defaults.data(forKey: "allStrains") == nil {
            
            let requestURL = StrainAPI.baseAPI + StrainAPI.APIKey + StrainAPI.allStrains
            Alamofire.request(requestURL).validate().responseJSON { (response) in
               
                if response.result.isSuccess {
                    let responseJSON = JSON(response.result.value!)

                    do {
                        defaults.set(try responseJSON.rawData(), forKey: "allStrains")
                        complete(.success(JSON(try responseJSON.rawData())))
                    } catch {
                        complete(.failure(BudsError.unableToGetAllStrains))
                    }
                    
                } else {
                    complete(.failure(BudsError.unableToGetAllStrains))
                }
            }
        } else {
            complete(.success(JSON(defaults.data(forKey: "allStrains") as Any)))
        }
    }
    
    
    /// Function to get the description of the strain from the Strain API based on it's STRAIN_ID
    static func getStrainDescription(strainID: Int, complete: @escaping(JSON?) -> ()) {
        
        let requestURL = StrainAPI.baseAPI + StrainAPI.APIKey + StrainAPI.searchForDescById + String(strainID)
        Alamofire.request(requestURL).validate().responseJSON { (response) in
            
            if response.result.isSuccess {
                let responseJSON = JSON(response.result.value!)
                complete(responseJSON)
            } else {
                complete(nil)
            }
        }
    }
    
    
    static func getStrain(name: String, complete: @escaping(Swift.Result<JSON, BudsError>) -> ()) {
        
        let strain = name.replacingOccurrences(of: " ", with: "%20")
        let requestURL = StrainAPI.baseAPI + StrainAPI.APIKey + StrainAPI.searchForStrainsByName + strain
        
        Alamofire.request(requestURL).validate().responseJSON { (response) in
            
            if response.result.isSuccess {
                let responseJSON = JSON(response.result.value!)
                complete(.success(responseJSON))
            } else {
                complete(.failure(BudsError.unableToGetStrain))
            }
        }
        
    }

}
