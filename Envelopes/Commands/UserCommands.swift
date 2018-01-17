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

    let userId: String
    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let usersRef = networkAccess.userIdRef(for: userId)
        networkAccess.createObject(at: usersRef, createNewChildId: false, removeId: false, parameters: ["userId": userId], core: core)
    }

}
