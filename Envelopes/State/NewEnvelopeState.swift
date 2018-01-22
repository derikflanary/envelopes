//
//  NewEnvelopeState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct NewEnvelopeState: State {

    // MARK: - Properties

    var newEnvelope = NewEnvelope()


    // MARK: - React function

    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<NewEnvelope>:
            newEnvelope = event.item
        case let event as Selected<Periodicity>:
            newEnvelope.periodicity = event.item
        default:
            break
        }

    }

}
