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
    
    
    static func logInUser(email: String, password: String, complete: @escaping (Result<Person, Error>) -> ()) {

        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if error == nil {
                guard let userID = Auth.auth().currentUser?.uid else {
                    complete(.failure(BudsError.unableToLogInUser))
                    return
                }
                
                Network.getUserInfo(userID: userID, complete: { userInfo in

                    let loggedInUser = Person(id: userID, name: userInfo["name"]!, email: userInfo["email"]!, birthday: userInfo["birthday"]!)
                    complete(.success(loggedInUser))
                })
            } else {
                complete(.failure(error!))
            }
        }
    }
    
    
    static func registerUser(name: String, birthday: String, email: String, password: String, complete: @escaping (Result<Person, Error>) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (createUserAuthResult, createUserError) in
            
            if createUserError == nil {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (signedInAuthResult, signedInError) in
                    
                    if signedInError == nil {
                        guard let userID = Auth.auth().currentUser?.uid else {
                            complete(.failure(BudsError.unableToLogInUser))
                            return
                        }
                        
                        let userData = ["name": name, "birthday": birthday, "email": email]
                        
                        Network.ref.child("users").child(userID).setValue(userData) { (error, ref) in
                            let person = Person(id: userID, name: name, email: email, birthday: birthday)
                            complete(.success(person))
                        }
                    } else {
                        complete(.failure(BudsError(rawValue: signedInError!.localizedDescription)!))
                    }
                })
            } else {
                complete(.failure(createUserError!))
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = WelcomeNavigationController()
            appDelegate.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    static func clearUserSettings() {
        Switcher.setUserDefaultsIsSignIn(false)
        Switcher.removeUserDefaultsModelController()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            Network.ref.child(FirebaseKeys.activity).removeAllObservers()
            Network.ref.child(FirebaseKeys.users).removeAllObservers()
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
            complete(information)
        }
        
    }
    
    
    static func displayActivityFeed(userID: String, complete: @escaping(Swift.Result<[Activity], BudsError>) -> ()) {
        
        ref.child(FirebaseKeys.activity).queryOrdered(byChild: FirebaseKeys.user).queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                if let dictionary = snapshot.value as? [String: [String: Any]] {
                    
                    var activities = [Activity]()
                    let dispatchGroup = DispatchGroup()
                    
                    for firActivity in dictionary.values {
                        dispatchGroup.enter()
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: firActivity, options: [])
                            let activity = try JSONDecoder().decode(Activity.self, from: jsonData)
                            activity.date = TimeHelper.getDateFromString(dateString: activity.time)
                            
                            if firActivity["race"] as? String == nil {
                                Network.getStrain(name: activity.strain) { result in
                                    
                                    switch result {
                                    case .success(let resultJSON):
                                        activity.race = resultJSON[0]["race"].stringValue
                                    case .failure:
                                        break
                                    }
                                    activities.insert(activity, at: 0)
                                    dispatchGroup.leave()
                                }
                            } else {
                                activities.insert(activity, at: 0)
                                dispatchGroup.leave()
                            }
                        } catch let error {
                            print(error)
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        
                        activities = activities.sorted(by: {
                            $0.date!.compare($1.date!) == .orderedDescending
                        })
                        complete(.success(activities))
                    }
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
        AF.request(requestURL).validate().responseJSON { (response) in
            
            var effectsDict = [[String: String]]()
            
            switch response.result {
            case .success(let value):
                let responseJSON = JSON(value)
                
                for item in responseJSON.arrayValue {
                    if item["type"].string != nil && item["effect"].string != nil {
                        effectsDict.append([item["effect"].string! : item["type"].string!])
                    }
                }
                defaults.set(effectsDict, forKey: "effects")
                complete(effectsDict)
            case .failure(_):
                complete(nil)
            }
        }
    }
    
    
    /// Returns a complete dictionary of all strains accessible to the application. Strain data could come from either User Defaults or a network call to the Strain API.
    /// This function returns a lot of data and if using the API can take a while to return
    static func getAllStrains(complete: @escaping(Swift.Result<JSON, BudsError>) -> ()) {

        if defaults.data(forKey: "allStrains") == nil {
            
            let requestURL = StrainAPI.baseAPI + StrainAPI.APIKey + StrainAPI.allStrains
            AF.request(requestURL).validate().responseJSON { (response) in
               
                switch response.result {
                case .success(let value):
                    let responseJSON = JSON(value)
                    do {
                        defaults.set(try responseJSON.rawData(), forKey: "allStrains")
                        complete(.success(JSON(try responseJSON.rawData())))
                    } catch {
                        complete(.failure(BudsError.unableToGetAllStrains))
                    }
                case .failure(_):
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
        AF.request(requestURL).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                complete(JSON(value))
            case .failure(_):
                complete(nil)
            }
        }
    }
    
    
    static func getStrain(name: String, complete: @escaping(Swift.Result<JSON, BudsError>) -> ()) {
        
        let strain = name.replacingOccurrences(of: " ", with: "%20")
        let requestURL = StrainAPI.baseAPI + StrainAPI.APIKey + StrainAPI.searchForStrainsByName + strain
        
        AF.request(requestURL).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                complete(.success(JSON(value)))
            case .failure(_):
                complete(.failure(BudsError.unableToGetStrain))
            }
        }     
    }

}
