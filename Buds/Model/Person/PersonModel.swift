//
//  PersonModel.swift
//  Buds
//
//  Created by Collin Browse on 6/19/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation

class PersonModel {
    var id: UUID!
    var name: PersonNameComponents!
    var email: String!
    var location: String!
    var birthday: Date!
    
    init(name: PersonNameComponents, email: String, location: String, birthday: Date) {
        id = UUID()
        self.name = name
        self.email = email
        self.location = location
        self.birthday = birthday 
        
    }
}
