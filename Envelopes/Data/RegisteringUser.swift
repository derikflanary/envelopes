//
//  RegisteringUser.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import Foundation

struct ResgisteringUser {
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    
    var fullname: String? {
        guard let firstName = firstName, let lastName = lastName else { return nil }
        return firstName + " " + lastName
    }
    
    var isValidEmail: Bool {
        guard let email = email else { return false }
        return email.contains("@") && email.contains(".")
    }
    
    var isRegistrationComplete: Bool {
        return email != nil && fullname != nil && password != nil && isValidEmail
    }
    
    var isSignInComplete: Bool {
        return email != nil && password != nil && isValidEmail
    }

}
