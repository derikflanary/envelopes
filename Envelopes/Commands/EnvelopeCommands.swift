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

struct AddEnvelope: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        let envelope = Envelope(newEnvelope: newEnvelope)
        let envelopeRef = networkAccess.envelopeRef()
        networkAccess.updateObject(at: envelopeRef, parameters: envelope.jsonObject(), core: core)
        core.fire(event: Created(item: envelope))
    }

}

struct UpdateEnvelope: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let envelope = core.state.envelopeState.selectedEnvelope else { return }
        let ref = networkAccess.envelopeRef()
        networkAccess.updateObject(at: ref, parameters: envelope.jsonObject(), core: core)
        core.fire(event: Updated(item: envelope))
    }

}

struct LoadEnvelopes: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        let query = networkAccess.envelopeRef().queryOrdered(byChild: Keys.ownerId).queryEqual(toValue: "guy")
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

struct AddExpense: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let envelope = core.state.envelopeState.selectedEnvelope else { return }
        let newExpense = core.state.envelopeState.newExpenseState.newExpense
        let expense = Expense(newExpense, envelopeId: envelope.id)
        let key = networkAccess.ref.child(Keys.expenses).childByAutoId().key
        let childUpdates: JSONObject = ["/\(Keys.expenses)/\(key)": expense.jsonObject()]
        networkAccess.ref.updateChildValues(childUpdates)
        core.fire(event: Created(item: expense))
        core.fire(command: UpdateEnvelope())
    }

}


struct LoadExpenses: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess
    let envelope: Envelope

    init(for envelope: Envelope) {
        self.envelope = envelope
    }

    func execute(state: AppState, core: Core<AppState>) {

        let query = networkAccess.expensesRef(envelopeId: envelope.id).queryOrdered(byChild: Keys.envelopeId).queryEqual(toValue: envelope.id)
        networkAccess.getObject(at: query, core: core) { json in
            if let json = json {
                let expenses: [Expense] = json.flatMap {
                    guard var object = $0.value as? JSONObject else { return nil }
                    object[Keys.id] = $0.key
                    do {
                        return try Expense(object: object)
                    } catch {
                        print(error)
                        return nil
                    }
                }
                var envelopeUpdated = self.envelope
                envelopeUpdated.expenses = expenses
                core.fire(event: Updated(item: envelopeUpdated))
            }
        }
    }

}

