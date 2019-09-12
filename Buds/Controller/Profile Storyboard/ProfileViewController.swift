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
    
    var username: String?
    var ref: DatabaseReference!
    var user: User?
    var modelController: ModelController! {
        willSet {
            print("Printing the Model Controller Person's name from ProfileVC: \(newValue.person.name)")
        }
    }
    @IBOutlet weak var exampleCard: UIImageView!
    @IBOutlet weak var exampleCard2: UIImageView!
    
    @IBOutlet weak var exampleCard3: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect to Realtime Database
        ref = Database.database().reference()
        
        exampleCard.layer.cornerRadius = 20.0
        exampleCard.layer.shadowColor = UIColor.gray.cgColor
        exampleCard.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        exampleCard.layer.shadowRadius = 20.0
        exampleCard.layer.shadowOpacity = 0.9
        exampleCard.alpha = 0.6
        
        exampleCard2.layer.cornerRadius = 20.0
        exampleCard2.layer.shadowColor = UIColor.gray.cgColor
        exampleCard2.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        exampleCard2.layer.shadowRadius = 20.0
        exampleCard2.layer.shadowOpacity = 0.9
        exampleCard2.alpha = 0.6
        
        exampleCard3.layer.cornerRadius = 20.0
        exampleCard3.layer.shadowColor = UIColor.gray.cgColor
        exampleCard3.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        exampleCard3.layer.shadowRadius = 20.0
        exampleCard3.layer.shadowOpacity = 0.9
        exampleCard3.alpha = 0.6
        
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


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = "This is some text"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top Strains"
    }
    
    
    
    
    
}
