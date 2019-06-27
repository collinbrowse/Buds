//
//  ProfileViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/27/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProfileViewController: UIViewController {
    
    @IBOutlet var profilePhotoImageView: UIImageView!
    @IBOutlet var nameTextView: UITextView!
    @IBOutlet var birthdayTextView: UITextView!
    @IBOutlet var locationTextView: UITextView!
    @IBOutlet var emailTextView: UITextView!
    
    var username: String?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect to Firebase
        ref = Database.database().reference()
        // Set Up View
        profilePhotoImageView.layer.masksToBounds = true
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        print("Intrinsic Content Size  \(profilePhotoImageView.intrinsicContentSize.width / 2)")
        print("Frame.size.width   \(profilePhotoImageView.frame.size.width / 2)")
    }
    
    func displayNewUser() {
            print(self.username!)
        ref.child("users").child(self.username!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? "Unable to Load User"
            let email = value?["email"] as? String ?? ""
            self.nameTextView.text = self.username
            self.locationTextView.text = email
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
