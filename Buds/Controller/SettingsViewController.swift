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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        print("Logout Button Pressed")
//        try! Auth.auth().signOut()
//        print("Logout Button Pressed")
//        self.dismiss(animated: true, completion: nil)
//        do {
//            try Auth.auth().signOut()
//            self.dismiss(animated: true, completion: nil)
//            print("logged out")
//        } catch (let error) {
//            print("Auth sign out failed: \(error)")
//        }
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "unwind", sender: nil)
//           self.presentingViewController?.dismiss(animated: true
//            , completion: {
//                self.performSegue(withIdentifier: "unwind", sender: nil)
//           })
            //self.dismiss(animated: true, completion: nil)
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
