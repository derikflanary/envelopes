//
//  EnvelopeCommands.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor
import Marshal

struct CreateEnvelope: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        let envelope = Envelope(newEnvelope: newEnvelope)
        let envelopeRef = networkAccess.envelopeIdRef()
        networkAccess.updateObject(at: envelopeRef, parameters: envelope.jsonObject(), core: core)
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

struct LoadEnvelopes: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let query = networkAccess.envelopeIdRef().queryOrdered(byChild: Keys.ownerId).queryEqual(toValue: "guy")
        networkAccess.getObject(at: query, core: core) { json in
            if let json = json {
                let envelopes: [Envelope] = json.flatMap {
                    guard var object = $0.value as? JSONObject else { return nil }
                    object[Keys.id] = $0.key
                    do {
                        return try Envelope(object: object)
                    } catch {
                        print(error)
                        return nil
                    }
                }
                core.fire(event: Loaded(items: envelopes))
            }
        }
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
