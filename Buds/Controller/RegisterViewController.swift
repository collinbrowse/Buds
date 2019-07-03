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
import CryptoSwift

class RegisterViewController: UIViewController {
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var birthdayTextfield: UITextField! // This will be converted to a date picked in the future
    private var datePicker: UIDatePicker?
    var username: String!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self,
                              action: #selector(RegisterViewController.dateChanged(datePicker:)),
                              for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.viewTapped(gestureRecognizer: )))
        view.addGestureRecognizer(tapGesture)
        birthdayTextfield.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextfield.text = dateFormatter.string(from: datePicker.date)
        //view.endEditing(true)
    }
    
    @IBAction func viewIconClicked(_ sender: Any) {
        passwordTextfield.isSecureTextEntry.toggle()
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        let email = emailTextfield.text
        var password = passwordTextfield.text
        let username = usernameTextfield.text
        let name = nameTextfield.text
        let location = locationTextField.text
        let birthday = birthdayTextfield.text
        passwordTextfield.text = nil
        
        if (!email!.isEmpty && !password!.isEmpty && !username!.isEmpty
            && !name!.isEmpty && !location!.isEmpty && !birthday!.isEmpty) {
            password = passwordHash(username: username!, password: password!)
            registerUser(name: name!, location: location!, birthday: birthday!, username: username!, email: email!, password: password!)
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
    
    func registerUser(name: String, location: String, birthday: String, username: String, email: String, password: String) {
        ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if !snapshot.exists() {
                self.ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
                    if !snapshot.exists() {
                        // email, password, and username have values and are unique
                        let usersRef = self.ref.child("users").child(username)
                        let values = ["name": name, "location": location, "birthday": birthday, "username": username, "email": email, "password": password]
                        usersRef.setValue(values, withCompletionBlock:  { (error, dbRef) in
                            if error != nil {
                                print("This is the error \(String(describing: error))")
                                return
                            }
                            else {
                                self.username = username
                                print("Saved user successfully")
                                SVProgressHUD.dismiss()
                                self.performSegue(withIdentifier: "goToHome", sender: self)
                            }
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
    
    func passwordHash(username: String, password: String) -> String {
        let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND99"
        return "\(password).\(username).\(salt)".sha256()
    }
    
    
}
