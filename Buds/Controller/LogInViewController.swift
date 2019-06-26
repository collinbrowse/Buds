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
import SVProgressHUD


class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        self.performSegue(withIdentifier: "goToChat", sender: self)
        
        //TODO: Log in the user
//        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
//            if (error != nil) {
//                print(error!)
//            }
//            else {
//                SVProgressHUD.dismiss()
//                self.performSegue(withIdentifier: "goToChat", sender: self)
//            }
//        }
        
        
    }
    
    
    
    
}
