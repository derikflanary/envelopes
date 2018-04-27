//
//  ErrorState.swift
//  Envelopes
//
//  Created by Derik Flanary on 4/26/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct ErrorState: State {

    var errorMessage: String?

    mutating func react(to event: Event) {
        errorMessage = nil
        switch event {
        case let event as UserAuthFailed:
            errorMessage = event.error.localizedDescription
        default:
            break
        }
    }


}
