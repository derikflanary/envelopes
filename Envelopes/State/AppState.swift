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

    mutating func react(to event: Event) {
        loginState.react(to: event)
    }

}
