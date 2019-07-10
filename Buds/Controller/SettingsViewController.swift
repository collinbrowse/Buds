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
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: TableViewController.classForCoder()) {
                    print("It is in stack")
                    //Your Process
                }
                else {
                    print("It is not in stack")
                }
            }
        }
        else {
            print("Unable to find the view controllers")
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "unwind", sender: nil)
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
