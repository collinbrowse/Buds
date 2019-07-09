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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func viewIconPressed(_ sender: Any) {
        passwordTextfield.isSecureTextEntry.toggle()
    }
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        let email = emailTextfield.text
        let password = passwordTextfield.text
        passwordTextfield.text = nil
        
        if ( !password!.isEmpty && !email!.isEmpty) {
            //password = passwordHash(username: username!, password: password!)
            //logInUser(username: username!, password: password!)
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] user, error in
                SVProgressHUD.dismiss()
                guard let strongSelf = self else { return }
                strongSelf.performSegue(withIdentifier: "goToHome", sender: self)

            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome" {
            let tabBarViewController = segue.destination as? UITabBarController
            if let destinationVC = tabBarViewController?.viewControllers![0] as? ProfileViewController {
                destinationVC.username = self.username
            }
        }
    }
    
    func logInUser(username: String, password: String) {
        ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if snapshot.exists() {
                self.ref.child("users").queryOrdered(byChild: "password").queryEqual(toValue: password).observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.exists() {
                            self.username = username
                            print("Logged In User Successfully")
                            SVProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    else {
                        self.showAlert(alertMessage: "Your Username/Password are incorrect")
                    }
                }
            } else {
                self.showAlert(alertMessage: "Your Username/Password are incorrect")
            }
        }
    }
    
    func passwordHash(username: String, password: String) -> String {
        let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND99"
        return "\(password).\(username).\(salt)".sha256()
    }
    
    
}
