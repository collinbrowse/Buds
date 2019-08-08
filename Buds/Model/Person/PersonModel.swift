//
//  PersonModel.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation
import UIKit

class Person {
    var id: UUID
    var name: PersonNameComponents
    var email: String
    var location: Location
    var birthday: Birthday
    var profilePicture: UIImage
    
    init(name: PersonNameComponents, email: String, location: Location, birthday: Birthday, profilePicture: UIImage) {
        id = UUID()
        self.name = name
        self.email = email
        self.location = location
        self.birthday = birthday 
        self.profilePicture = profilePicture
    }
}
