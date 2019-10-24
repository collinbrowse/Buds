//
//  Switcher.swift
//  Buds
//
//  Created by Collin Browse on 10/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit


class Switcher {

    static func updateRootViewController() {

        let status = UserDefaults.standard.bool(forKey: "isSignIn")
        var rootViewController : UIViewController?

        #if DEBUG
        //print(status)
        #endif

        if (status == true) {
            print("User Defaults says user is logged in")
            let mainStoryBoard = UIStoryboard(name: "TabBar", bundle: nil)
            let mainTabBarController = mainStoryBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            rootViewController = mainTabBarController
        } else {
            print("User Defaults says user is logged out")
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let signInViewController = mainStoryBoard.instantiateViewController(withIdentifier: "welcomeNavigationController") as! UINavigationController
            rootViewController = signInViewController
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController

    }

    
    // Function to add model controller information to user defaults once signed in
    // Function to remove model controller from user defaults
    // Function to gain access to user Defaults if already signed in
    static func getUserDefaultsModelController() -> ModelController {
        
        let dict = UserDefaults.standard.dictionary(forKey: "modelController")
        
        let modelController = ModelController()
        modelController.person = Person(id: dict?["id"] as! String,
                                        name: dict?["name"] as! String,
                                        email: dict?["email"] as! String,
                                        location: dict?["location"] as! String,
                                        birthday: dict?["birthday"] as! String,
                                        profilePictureURL: dict?["profilePictureURL"] as! String)

        return modelController
        
    }
    
    static func setUserDefaultsModelController(modelController: ModelController) {
        
        var dict = [String: String]()
        
        dict["id"] = modelController.person.id
        dict["name"] = modelController.person.name
        dict["email"] = modelController.person.email
        dict["location"] = modelController.person.location
        dict["birthday"] = modelController.person.birthday
        dict["profilePictureURL"] = modelController.person.profilePictureURL
        
        UserDefaults.standard.set(dict, forKey: "modelController")
    }
    
    static func removeUserDefaultsModelController() {
        UserDefaults.standard.set(nil, forKey: "modelController")
    }
    
    static func setUserDefaultsIsSignIn(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: "isSignIn")
    }
    
    static func getUserDefaultsIsSignIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isSignIn")
    }
    
}