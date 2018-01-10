//
//  FirebaseNetworkAccess.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/6/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Firebase
import Reactor

// MARK: - Firebase network access

struct FirebaseNetworkAccess: FirebaseEnvelopesAccess {

    // MARK: - Shared instance

    static let sharedAccess = FirebaseNetworkAccess()


    // MARK: - Internal properties

    var ref: DatabaseReference {
        return Database.database().reference()
    }

    var currentApp: FirebaseApp? {
        return ref.database.app
    }


    // MARK: - Initializers

    init() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }

}


// MARK: - App specific Firebase access protocol

protocol FirebaseEnvelopesAccess: FirebaseReactorAccess {
    
}

extension FirebaseEnvelopesAccess {

    // MARK: - Query helpers

    func userIdRef(for userId: String) -> DatabaseReference {
        return ref.child(Keys.users).child(userId)
    }

}