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
        var password = passwordTextfield.text
        passwordTextfield.text = nil
        
        if ( !password!.isEmpty && !email!.isEmpty) {
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] user, error in
                password = nil
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

        // If the user tried to log in....
        let tabBarViewController = segue.destination as? UITabBarController
        if let destinationVC = tabBarViewController?.viewControllers![1] as? ProfileViewController {
            destinationVC.modelController = modelController
            print("LogInViewController.modelController -> ProfileViewController")
        }
        print("Unable to access the Profile VC in the tab bar")
        
    }
    
    
}
