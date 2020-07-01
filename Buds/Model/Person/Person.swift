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
    
    
    var id: String 
    var name: String
    var email: String
    var location: String?
    var birthday: String
    var profilePicture: UIImage?
    var profilePictureURL: String?
    
    init(id: String, name: String, email: String, birthday: String) {
        self.id = id
        self.name = name
        self.email = email
        self.birthday = birthday 
    }
    
    
    init(id: String, name: String, email: String, location: String, birthday: String, profilePictureURL: String, profilePicture: UIImage) {
        self.id = id
        self.name = name
        self.email = email
        self.location = location
        self.birthday = birthday
        self.profilePictureURL = profilePictureURL
        self.profilePicture = profilePicture
    }
    
    
    mutating func setProfilePicture(_ picture: UIImage) {
        self.profilePicture = picture
    }
}
