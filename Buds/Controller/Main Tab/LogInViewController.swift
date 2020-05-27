//
//  LogInViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/25/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD
import CryptoSwift

class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    var ref: DatabaseReference!
    var username: String!
    var modelController: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func viewIconPressed(_ sender: Any) {
        passwordTextfield.isSecureTextEntry.toggle()
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        let email = emailTextfield.text
        var password = passwordTextfield.text
        passwordTextfield.text = nil
        
        if ( !password!.isEmpty && !email!.isEmpty) {
            
            Network.logInUser(email: email!, password: password!) { (user) in
                
                password = nil // security
                
                // Check to make sure user was logged in Successfully,
                // If not...
                if user == nil {
                    SVProgressHUD.dismiss()
                    self.showAlert(alertMessage: "Incorrect Username/Password")
                    return
                }
                
                // If they were...
                self.modelController.person = user
                Switcher.setUserDefaultsIsSignIn(true)
                Switcher.setUserDefaultsModelController(modelController: self.modelController)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = BudsTabBarController()
                appDelegate.window?.makeKeyAndVisible()
            }
        }
        else {
            SVProgressHUD.dismiss()
            password = nil
            self.showAlert(alertMessage: "All Fields Must Be Filled Out")
        }
    }
    
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "There was an error", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToHomeFromLogIn" {
        
            if let tabBarViewController = segue.destination as? UITabBarController {
            
                // FIX: Safely unwrap the tab Bar Controller
                for n in 0...tabBarViewController.viewControllers!.count-1 {
                    let navController = tabBarViewController.viewControllers![n] as! UINavigationController
                    if navController.topViewController is ActivityFeedController {
                        let vc = navController.topViewController as! ActivityFeedController
                        vc.modelController = modelController
                    } else if navController.topViewController is ProfileViewController {
                        let vc = navController.topViewController as! ProfileViewController
                        vc.modelController = modelController
                    } else if navController.topViewController is NewActivityViewController {
                        let vc = navController.topViewController as! NewActivityViewController
                        vc.modelController = modelController
                    } else if navController.topViewController is SettingsViewController {
                        let vc = navController.topViewController as! SettingsViewController
                        vc.modelController = modelController
                    }
                }
            }
        }
        else {
            print("Unable to find the specified Segue")
        }
        
    }
}
