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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        logoutButton.layer.cornerRadius = 8
        logoutButton.showsTouchWhenHighlighted = true
        logoutButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        logoutButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        logoutButton.layer.shadowOpacity = 2.0
        logoutButton.layer.shadowRadius = 1.0
        logoutButton.layer.masksToBounds = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.user = user
            } else {
                // No User is signed in.
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let viewController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "welcomeNavigationController") as! UINavigationController;
            present(viewController, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
