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

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        let envelope = Envelope(newEnvelope: newEnvelope)
        let envelopeRef = networkAccess.envelopeIdRef(for: envelope.id)
        networkAccess.createObject(at: envelopeRef, createNewChildId: false, removeId: false, parameters: envelope.jsonObject(), core: core)
        core.fire(event: Created(item: envelope))
    }

}

struct UpdateEnvelope: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess
    let envelope: Envelope

    init(envelope: Envelope) {
        self.envelope = envelope
    }

    func execute(state: AppState, core: Core<AppState>) {

    }

}

struct CreateExpense: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let newExpense = core.state.envelopeState.newExpenseState.newExpense
        let expense = Expense(newExpense)
        core.fire(event: Created(item: expense))
    }

}
