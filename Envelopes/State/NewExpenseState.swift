//
//  NewExpenseState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct NewExpenseState: State {

    // MARK: - Properties

    var newExpense = NewExpense()


    // MARK: - React function

    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<NewExpense>:
            newExpense = event.item
        default:
            break
        }

    }

}
