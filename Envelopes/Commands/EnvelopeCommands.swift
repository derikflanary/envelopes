//
//  EnvelopeCommands.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct CreateEnvelope: Command {

    func execute(state: AppState, core: Core<AppState>) {
        let newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        let envelope = Envelope(newEnvelope: newEnvelope)
        core.fire(event: Created(item: envelope))
    }

}

struct CreateExpense: Command {

    func execute(state: AppState, core: Core<AppState>) {
        let newExpense = core.state.envelopeState.newExpenseState.newExpense
        let expense = Expense(newExpense)
        core.fire(event: Created(item: expense))
    }

}
