//
//  User.swift
//  Fusion
//
//  Created by Cristina Berlinschi on 20/12/2023.
//
// In user model is where to put the rest of the other fields I would associate with the user like phonenumber, dob, etc...

import Foundation


struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) { //looks at full name and grabs initials
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
}


extension User{ //creating mock user
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Cristina Berlinschi", email: "test@gmail.com")
}
