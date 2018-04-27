//
//  AppState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/6/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

enum App {
    static var sharedCore = Core(state: AppState(), middlewares: [])
}

struct AppState: State {

    var loginState = LoginState()
    var envelopeState = EnvelopeState()
    var errorState = ErrorState()

    mutating func react(to event: Event) {
        switch event {
        case _ as UserLoggedOut:
            loginState = LoginState()
            envelopeState = EnvelopeState()
        default:
            break
        }
        loginState.react(to: event)
        envelopeState.react(to: event)
        errorState.react(to: event)
    }

}
