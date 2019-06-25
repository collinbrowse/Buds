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
import SVProgressHUD


class RegisterViewController: UIViewController {
    
    
    //Pre-linked IBOutlets
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "goToChat", sender: self)
        //TODO: Set up a new user on our Firbase database
//        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
//            (user, error) in
//            if error != nil {
//                print(error!)
//            }
//            else {
//                SVProgressHUD.dismiss()
//                self.performSegue(withIdentifier: "goToChat", sender: self)
//            }
//        }
        
        
        
        
        
    }
    
    
}
