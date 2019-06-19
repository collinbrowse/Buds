//
//  ViewController.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Connect to Firebase
        var name = PersonNameComponents()
        name.givenName = "Collin"
        name.familyName = "Browse"
        let birthday = Birthday(month: "January", day: 1, year: 1990)
        let email = "mail@google.com"
        let location = Location(city: "Steamboat Springs", state: "Colorado")
        let person = PersonModel(name: name, email: email, location: location, birthday: birthday)
    }


}

