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
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var birthdayTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var usernameTextView: UITextView!
    
    var handle: AuthStateDidChangeListenerHandle?
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
        
        // Pull the user's data from the Model, not the network
        nameTextView.text = modelController.person.name
        birthdayTextView.text = modelController.person.birthday
        locationTextView.text = modelController.person.location
        emailTextView.text = modelController.person.email
        
        if modelController.person.profilePicture != nil {
            profilePictureImageView.image = modelController.person.profilePicture
        } else {
            
            // Make a network call to find the profile picture
            Network.getProfilePicture(userID: modelController.person.id) { (profilePicture) in
                self.profilePictureImageView.image = profilePicture
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    // We want to change this to pull into the user profile information from a cashed resource
    func displayUser() {
        
        
        // Step 1: Show Loading Screen
        SVProgressHUD.show()
        print("Display User")
        
        //Step 2: See if we have a Person Object
//        var cache = NSCache<NSString, Person>()
//        let taskKey = "currentUser" as NSString
//        if let cachedTask = cache.object(forKey: taskKey) {
//            // Display the User's Profile Information
//        } else {
//
//        }
        
        if (user?.email != nil) {
            
            // Get the Profile Information from Realtime Database
            ref.child("users").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
                
                print("Found the user in firebase")
                // Get all the information we can from Realtime Database
                let value = snapshot.value as? NSDictionary

                var information = [String: String]()
                information["name"] = value?["name"] as? String ?? ""
                information["email"] = value?["email"] as? String ?? ""
                information["birthday"] = value?["birthday"] as? String ?? ""
                information["location"] = value?["location"] as? String ?? ""
                information["username"] = value?["username"] as? String ?? ""
                
                
                if let profilePictureURL = value?["profilePicture"] as? String {
                    // Get the Profile Picture from Firebase Storage
                    let storageRef = Storage.storage().reference(forURL: profilePictureURL)
                    storageRef.getData(maxSize: 4*1024*1024, completion: { [weak self] (data, error) in
                        if let error = error {
                            print("There was an error getting the profile picture: \(error.localizedDescription)")
                            return
                        }
                        if let data = data {
                            
                            // Now that we have our profile picture, we can set all of our information
                            self?.profilePictureImageView.image = UIImage(data: data)
                            self?.setProfileUI(information: information)
                            SVProgressHUD.dismiss()
                        }
                    })
                }
                else {
                    // Set our information without a profile picture
                    self.setProfileUI(information: information)
                    SVProgressHUD.dismiss()
                }
                
            }
        } else {
            self.nameTextView.text = "Unable to Load User"
        }
        
    }
    
    // Helper functon to set the UI components with information from Firebase
    func setProfileUI(information: [String: String]) {
        print("Setting the Profile UI")
        nameTextView.text = information["name"]
        birthdayTextView.text = information["birthday"]
        locationTextView.text = information["location"]
        emailTextView.text = information["email"]
        usernameTextView.text = information["username"]
    }
    
//    class NameTextView: UITextView {
//
//        override init(frame: CGRect, textContainer: NSTextContainer?) {
//            super.init(frame: frame, textContainer: textContainer)
//            print("Hello")
//            backgroundColor = .blue
//            textColor = .black
//            textAlignment = .center
//            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        override var intrinsicContentSize: CGSize {
//            let originalContentSize = super.intrinsicContentSize
//            let width = originalContentSize.width + 16
//            let height = originalContentSize.height + 12
//
//            layer.cornerRadius = height / 2
//            layer.masksToBounds = true
//            return CGSize(width: width, height: height)
//        }
//    }
    
    
}
