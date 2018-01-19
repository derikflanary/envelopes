//
//  LoginCommands.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/18/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct SignUpNewUser: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let registeringUser = core.state.loginState.registeringUser
        guard let email = registeringUser.email, let password = registeringUser.password else { return }
        networkAccess.signUpUser(with: email, and: password, core: core) { userId in
            guard let userId = userId, let firstName = registeringUser.firstName, let lastName = registeringUser.lastName else { return }
            let user = AuthUser(id: userId, email: email, firstName: firstName, lastName: lastName)
            core.fire(command: CreateNewUser(user: user))
            core.fire(event: LoggedIn(user: user))
        }
    }

}

struct Login: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let registeringUser = state.loginState.registeringUser
        guard let email = registeringUser.email, let password = registeringUser.password else { return }
        networkAccess.logInUser(with: email, and: password, core: core)
    }

}

struct ForgotPassword: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let email = state.loginState.registeringUser.email else { return }
        networkAccess.resetPassword(for: email, app: nil, core: core)
    }

}
