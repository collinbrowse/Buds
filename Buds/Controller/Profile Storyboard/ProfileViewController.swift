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
import FirebaseStorage
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bubble1: UIButton!
    @IBOutlet weak var bubble2: UIButton!
    @IBOutlet weak var bubble3: UIButton!
    
    var username: String?
    var ref: DatabaseReference!
    var user: User?
    var modelController: ModelController! {
        willSet {
            print("Printing the Model Controller Person's name from ProfileVC: \(newValue.person.name)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect to Realtime Database
        ref = Database.database().reference()
        
        bubble1.layer.masksToBounds = true
        bubble1.layer.cornerRadius = 50
        bubble1.layer.shadowOpacity = 0.5
        bubble1.layer.shadowRadius = 1
        bubble1.layer.shadowOffset = CGSize(width: 0, height: 1)
        bubble1.backgroundColor = .clear
        bubble1.layer.borderWidth = 1
        bubble1.layer.borderColor = UIColor.black.cgColor
        bubble1.setTitle("OG KUSH", for: .normal)
        
        bubble2.layer.masksToBounds = true
        bubble2.layer.cornerRadius = 50
        bubble2.layer.shadowOpacity = 0.5
        bubble2.layer.shadowRadius = 1
        bubble2.layer.shadowOffset = CGSize(width: 0, height: 1)
        bubble2.backgroundColor = .clear
        bubble2.layer.borderWidth = 1
        bubble2.layer.borderColor = UIColor.black.cgColor
        bubble2.setTitle("Blue Dream", for: .normal)
        
        bubble3.layer.masksToBounds = true
        bubble3.layer.cornerRadius = 50
        bubble3.layer.shadowOpacity = 0.5
        bubble3.layer.shadowRadius = 1
        bubble3.layer.shadowOffset = CGSize(width: 0, height: 1)
        bubble3.backgroundColor = .clear
        bubble3.layer.borderWidth = 1
        bubble3.layer.borderColor = UIColor.black.cgColor
        bubble3.setTitle("Sour Diesel", for: .normal)
        
        
        if modelController.person.profilePicture != nil {
            setUpNavbar(modelController.person.profilePicture!)
        } else {
            
            // Make a network call to find the profile picture
            Network.getProfilePicture(userID: modelController.person.id) { (profilePicture) in
                self.setUpNavbar(profilePicture)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
}


extension ProfileViewController {
    
    // Add the User's profile picture to the navigation bar
    func setUpNavbar(_ image: UIImage) {
        
        // Alter the Navigation Bar
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        // Set up/Gain Access to everything we will need
        let navController = navigationController!
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let titleView = UIView()
        let profileImageView = UIImageView(image: image)
        
        
        // Create the View in the Title Bar and add the image
        titleView.frame = CGRect(x: 0, y: 0, width: bannerWidth, height: bannerHeight)
        titleView.addSubview(profileImageView)
        
        // Style & Position Image within the titleView
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // Finally set the titleView of the nav bar to our new title view
        navigationItem.titleView = titleView
        SVProgressHUD.dismiss()
    }
    
    
}
