//
//  AppDelegate.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set up Firebase App
        FirebaseApp.configure()
        print("App Delegate is switching the root view controller")
        Switcher.updateRootViewController()
        return true
            
//            let ref = Database.database().reference()
//            // We can get the user's info here
//            // Get the Profile Information from Realtime Database
//            ref.child("users").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
//
//                // Get all the information we can from Realtime Database
//                let value = snapshot.value as? NSDictionary
//
//                var information = [String: String]()
//                information["name"] = value?["name"] as? String ?? ""
//                information["email"] = value?["email"] as? String ?? ""
//                information["birthday"] = value?["birthday"] as? String ?? ""
//                information["location"] = value?["location"] as? String ?? ""
//                information["username"] = value?["username"] as? String ?? ""
//                information["profilePictureURL"] = value?["profilePicture"] as? String ?? ""
//
//                // Access the storyboard
//                let storyboard = UIStoryboard(name: "Main", bundle: nil);
//
//                // Access the TabBarController within this storyboard
//                let tabBarController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController;
//
//                Network.getProfilePicture(userID: user!.uid) { (profilePicture) in
//
//                    // Loop through the Tab Bar Items
//                    for n in 0...tabBarController.viewControllers!.count-1 {
//
//                        // Every tab bar item has a Nav Controller so this is ok
//                        let navController = tabBarController.viewControllers![n] as! UINavigationController
//
//                        // Once We find the ActivityFeedController...
//                        if navController.topViewController is ActivityFeedController {
//                            let vc = navController.topViewController as? ActivityFeedController
//                            let newModelController = ModelController()
//                            newModelController.person = Person(id: user!.uid,
//                                                                name: information["name"]!,
//                                                               email: information["email"]!,
//                                                               location: information["location"]!,
//                                                               birthday: information["birthday"]!,
//                                                               profilePictureURL: information["profilePictureURL"]!,
//                                                               profilePicture: profilePicture)
//                            vc!.modelController = newModelController
//
//                        } else if navController.topViewController is ProfileViewController {
//                            let vc = navController.topViewController as? ProfileViewController
//                            let newModelController = ModelController()
//                            newModelController.person = Person(id: user!.uid,
//                                                               name: information["name"]!,
//                                                               email: information["email"]!,
//                                                               location: information["location"]!,
//                                                               birthday: information["birthday"]!,
//                                                               profilePictureURL: information["profilePictureURL"]!,
//                                                               profilePicture: profilePicture)
//                            vc!.modelController = newModelController
//
//                        } else if navController.topViewController is NewActivityViewController {
//                            let vc = navController.topViewController as? NewActivityViewController
//                            let newModelController = ModelController()
//                            newModelController.person = Person(id: user!.uid,
//                                                               name: information["name"]!,
//                                                               email: information["email"]!,
//                                                               location: information["location"]!,
//                                                               birthday: information["birthday"]!,
//                                                               profilePictureURL: information["profilePictureURL"]!,
//                                                            profilePicture: profilePicture)
//                            vc!.modelController = newModelController
//
//                        } else if navController.topViewController is SettingsViewController {
//                            let vc = navController.topViewController as? SettingsViewController
//                            let newModelController = ModelController()
//                            newModelController.person = Person(id: user!.uid,
//                                                               name: information["name"]!,
//                                                               email: information["email"]!,
//                                                               location: information["location"]!,
//                                                               birthday: information["birthday"]!,
//                                                               profilePictureURL: information["profilePictureURL"]!,
//                                                               profilePicture: profilePicture)
//                            vc!.modelController = newModelController
//
//                        }
//                    }
//                }
//                self.window!.rootViewController = tabBarController
//                self.window!.makeKeyAndVisible()
//
//            }
//
//        }
            
        // User is not logged in so show the Welcome View Controller
//        else {
//
//            if let welcomeViewController = window?.rootViewController as? WelcomeViewController {
//                welcomeViewController.modelController = ModelController()
//            }
//
//        }
    
        // If for some reason above didn't work, set the Welcome View Controller without the Model Controller
//        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

