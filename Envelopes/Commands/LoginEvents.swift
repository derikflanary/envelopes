//
//  LoginEvents.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import Foundation
import Reactor

struct EmailUpdated: Event {
    let email: String
}

struct FirstNameUpdated: Event {
    let firstName: String
}

struct LastNameUpdated: Event {
    let lastName: String
}

struct PasswordUpdated: Event {
    let password: String
}

struct LoggedIn: Event {
    let user: AuthUser
}
