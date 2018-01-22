//
//  NewDepositState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/21/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct NewDepositState: State {

    // MARK: - Properties

    var newDeposit = NewDeposit()


    // MARK: - React function

    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<NewDeposit>:
            newDeposit = event.item
        default:
            break
        }

    }

}

