//
//  SettingsViewController.swift
//  Buds
//
//  Created by Collin Browse on 7/9/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase 

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: User?
    var modelController: ModelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Switcher.getUserDefaultsIsSignIn() {
           modelController = Switcher.getUserDefaultsModelController()
        } else {
            Switcher.updateRootViewController()
        }
        
        
        // Do any additional setup after loading the view.
        logoutButton.layer.cornerRadius = 8
        logoutButton.showsTouchWhenHighlighted = true
        logoutButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        logoutButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        logoutButton.layer.shadowOpacity = 2.0
        logoutButton.layer.shadowRadius = 1.0
        logoutButton.layer.masksToBounds = false
        
    }
    
    // Check for User's Logged In State
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        print("Logout button pressed")
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        modelController = nil
        Network.logOutUser()
    }
    
}
