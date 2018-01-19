//
//  User.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/19/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

struct AuthUser: JSONMarshaling, Unmarshaling {

    var id: String
    var email: String?
    var firstName: String?
    var lastName: String?

    var fullname: String? {
        guard let firstName = firstName, let lastName = lastName else { return nil }
        return firstName + " " + lastName
    }

    init(id: String, email: String?, firstName: String?, lastName: String?) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }

    init(object: MarshaledObject) throws {
        id = try object.value(for: Keys.id)
        email = try object.value(for: Keys.email)
        firstName = try object.value(for: Keys.firstName)
        lastName = try object.value(for: Keys.lastName)
    }

    func jsonObject() -> JSONObject {
        return [Keys.id: id,
                Keys.email: email,
                Keys.firstName: firstName,
                Keys.lastName: lastName]
    }

}
