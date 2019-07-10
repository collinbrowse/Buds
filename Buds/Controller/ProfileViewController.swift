//
//  ProfileViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/27/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var birthdayTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var usernameTextView: UITextView!
    
    var username: String?
    var ref: DatabaseReference!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect to Realtime Database
        ref = Database.database().reference()
        // Connect to Auth
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                // Save the user
                self.user = user
                // Set Up View
                self.profilePhotoImageView.layer.masksToBounds = true
                self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.size.width / 2
                //print("Intrinsic Content Size  \(profilePhotoImageView.intrinsicContentSize.width / 2)")
                //print("Frame.size.width   \(profilePhotoImageView.frame.size.width / 2)")
                self.displayNewUser()
            }
        }
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: SettingsViewController.classForCoder()) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        //handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        //}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func displayNewUser() {

        if (user?.email != nil) {
            ref.child("users").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let birthday = value?["birthday"] as? String ?? ""
                let location = value?["location"] as? String ?? ""
                let username = value?["username"] as? String ?? ""
                self.nameTextView.text = name
                self.birthdayTextView.text = birthday
                self.locationTextView.text = location
                self.emailTextView.text = email
                self.usernameTextView.text = username
            }
        } else {
            username = "Unable to Load User"
            self.nameTextView.text = username
        }
        
    }
    
    
    class NameTextView: UITextView {
        
        override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            print("Hello")
            backgroundColor = .blue
            textColor = .black
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let width = originalContentSize.width + 16
            let height = originalContentSize.height + 12
            
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: width, height: height)
        }
    }
    
    
}
