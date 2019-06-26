//
//  ViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import SVProgressHUD

class ViewController: UIViewController {

    var db: Firestore!
    
    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var nameTextView: UITextView!
    @IBOutlet var locationTextView: UITextView!
    @IBOutlet var birthdayTextView: UITextView!
    @IBOutlet var emailTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var name = PersonNameComponents()
//        name.givenName = "Collin"
//        name.familyName = "Browse"
//        let birthday = Birthday(month: "January", day: 1, year: 1990)
//        let email = "mail@google.com"
//        let location = Location(city: "Steamboat Springs", state: "Colorado")
//        let person = PersonModel(name: name, email: email, location: location, birthday: birthday)
        var username = "username_"
        let number = String(Int.random(in: 0 ..< 100))
        username+=number
        
        // Connect to Firebase
        db = Firestore.firestore()
        
        //addNewUser(username: username, name: name, email: email, location: location, birthday: birthday)
        displayNewUser(username: username)
        
    }
    
    func displayNewUser(username: String) {
        print(username)
        let usersRef = db.collection("users").document(username)
        
        usersRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let city = document["location.city"] as! String
                let state = document["location.state"] as! String
                let month = document["birthday.month"] as! String
                let day = document["birthday.day"] as? Int
                let year = document["birthday.year"] as? Int
                self.nameTextView.text = username
                self.locationTextView.text = city + ", " + state
                self.birthdayTextView.text = "\(month) \(day!)" + ", " + "\(year!)"
                self.emailTextView.text = document["email"] as? String
            } else {
                self.nameTextView.text = "Unable to load user"
                self.locationTextView.text = ""
                self.birthdayTextView.text = ""
                self.emailTextView.text = ""
                print("Unable to find user")
                SVProgressHUD.dismiss()
            }
        }
        
    }
    
    func addNewUser(username: String, name: PersonNameComponents, email: String, location: Location, birthday: Birthday) {

        let usersRef = db.collection("users")
        usersRef.document(username).setData(
            ["name": [
                "first": name.givenName!,
                "last": name.familyName!
                ],
             "email": email,
             "location": [
                "state": location.state,
                "city": location.city,
                ],
             "birthday": [
                "year": birthday.year!,
                "month": birthday.month!,
                "day": birthday.day!
                ]
        ]) {err in
            if let err = err {
                print("Error adding person: \(err)")
            } else {
                print("Document added with ID: \(usersRef.document())")
            }
        }
    }
    
    func printTestData() {
        db.collection("users").getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
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

