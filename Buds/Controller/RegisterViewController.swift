//
//  RegisterViewController.swift
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


class RegisterViewController: UIViewController {
    
    
    //Pre-linked IBOutlets
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        let email = emailTextfield.text
        let password = passwordTextfield.text
        let username = usernameTextfield.text
        
        //let isUnique = verifyUnique(email: email!, username: username!)
        if (!email!.isEmpty || !password!.isEmpty || !username!.isEmpty) {
            registerUser(username: username!, email: email!, password: password!)
        }
        else {
            SVProgressHUD.dismiss()
            self.showAlert(alertMessage: "All Fields Must Be Filled Out")
        }
       
    }
    
    func showAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Unable to Register", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    func registerUser(username: String, email: String, password: String) {
        ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if !snapshot.exists() {
                self.ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
                    if !snapshot.exists() {
                        // email, password, and username have values and are unique
                        let usersRef = self.ref.child("users").child(username)
                        let values = ["email": email, "username": username, "password": password]
                        usersRef.setValue(values, withCompletionBlock:  { (error, dbRef) in
                            if error != nil {
                                print("This is the error \(String(describing: error))")
                                return
                            }
                            else {
                                print("error was empty")
                            }
                            print("Saved user successfully")
                            SVProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "goToChat", sender: self)
                        })
                        
                    } else {
                        self.showAlert(alertMessage: "That Email Already Exists")
                    }
                }
            } else {
                self.showAlert(alertMessage: "That Username Already Exists")
            }
        }
    }
    
    
}
