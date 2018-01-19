//
//  UserCommands.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/6/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct CreateNewUser: Command {

    let user: AuthUser
    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let usersRef = networkAccess.userIdRef(for: user.id)
        networkAccess.createObject(at: usersRef, createNewChildId: false, removeId: false, parameters: user.jsonObject(), core: core)
    }

}

struct LoadUser: Command {

    let userId: String
    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let usersRef = networkAccess.userIdRef(for: userId)
        networkAccess.getObject(at: usersRef, core: core) { json in
            if let json = json {
                do {
                    let user =  try AuthUser(object: json)
                } catch {
                    print(error)
                }
            }
        }
    }

}
