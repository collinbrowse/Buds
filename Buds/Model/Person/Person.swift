//
//  PersonModel.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit

struct Person {
    
    
    private var id: UUID
    var name: String
    var email: String
    var location: String
    var birthday: String
    var profilePicture: UIImage?
    var profilePictureURL: String
    
    init(name: String, email: String, location: String, birthday: String, profilePictureURL: String) {
        id = UUID()
        self.name = name
        self.email = email
        self.location = location
        self.birthday = birthday 
        self.profilePictureURL = profilePictureURL
    }
    
    mutating func setProfilePicture(_ picture: UIImage) {
        self.profilePicture = picture
    }
}
