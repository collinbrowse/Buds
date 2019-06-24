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

class ViewController: UIViewController {

    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        var name = PersonNameComponents()
        name.givenName = "Collin"
        name.familyName = "Browse"
        let birthday = Birthday(month: "January", day: 1, year: 1990)
        let email = "mail@google.com"
        let location = Location(city: "Steamboat Springs", state: "Colorado")
        let person = PersonModel(name: name, email: email, location: location, birthday: birthday)
        
        // Connect to Firebase
        db = Firestore.firestore()
        
        addTestData(name: name, email: email, location: location, birthday: birthday)
        printTestData()
    }
    
    func addTestData(name: PersonNameComponents, email: String, location: Location, birthday: Birthday) {
        //var ref: DocumentReference? = nil
        let usersRef = db.collection("users")
        usersRef.document(name.familyName!).setData(
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


}

