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
import Firebase

struct UpdatedEnvelopeTotal: Event {
    let newTotal: Double
}

struct AddEnvelope: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let user = state.loginState.user else { return }
        let newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        var envelope = Envelope(newEnvelope: newEnvelope)
        envelope.ownerId = user.id
        let envelopeRef = networkAccess.envelopeRef()
        networkAccess.updateObject(at: envelopeRef, parameters: envelope.jsonObject(), core: core)
        core.fire(event: Created(item: envelope))
    }

}

struct DeleteEnvelope: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let envelope = state.envelopeState.selectedEnvelope else { return }
        let envelopeRef = networkAccess.envelopeRef().child(envelope.id)
        networkAccess.removeObject(at: envelopeRef, core: core)
        core.fire(event: Deleted(item: envelope))
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

struct EditEnvelope: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let envelope = core.state.envelopeState.updatedEnvelope else { return }
        let ref = networkAccess.envelopeRef()
        networkAccess.updateObject(at: ref, parameters: envelope.jsonObject(), core: core)
        core.fire(event: Updated(item: envelope))
    }

}

struct LoadEnvelopes: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let user = state.loginState.user else { return }
        let query = networkAccess.envelopeRef().queryOrdered(byChild: Keys.ownerId).queryEqual(toValue: user.id)
        networkAccess.getObject(at: query, core: core) { json in
            var envelopes = [Envelope]()
            if let json = json {
                envelopes = json.compactMap {
                    guard var object = $0.value as? JSONObject else { return nil }
                    object[Keys.id] = $0.key
                    do {
                        return try Envelope(object: object)
                    } catch {
                        print(error)
                        return nil
                    }
                }
            }
            core.fire(event: Loaded(items: envelopes))
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

struct DeleteExpense: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess
    let expense: Expense

    func execute(state: AppState, core: Core<AppState>) {
        let ref = networkAccess.expensesRef().child(expense.id)
        networkAccess.removeObject(at: ref, core: core)
        core.fire(event: Deleted(item: expense))
        core.fire(command: UpdateEnvelope())
    }

}

struct DeleteDeposit: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess
    let deposit: Deposit

    func execute(state: AppState, core: Core<AppState>) {
        let ref = networkAccess.depositsRef().child(deposit.id)
        networkAccess.removeObject(at: ref, core: core)
        core.fire(event: Deleted(item: deposit))
        core.fire(command: UpdateEnvelope())
    }

}

struct AddDeposit: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess

    func execute(state: AppState, core: Core<AppState>) {
        guard let envelope = core.state.envelopeState.selectedEnvelope else { return }
        let newDeposit = core.state.envelopeState.newDepositState.newDeposit
        let deposit = Deposit(newDeposit, envelopeId: envelope.id)
        let key = networkAccess.ref.child(Keys.deposits).childByAutoId().key
        let childUpdates: JSONObject = ["/\(Keys.deposits)/\(key)": deposit.jsonObject()]
        networkAccess.ref.updateChildValues(childUpdates)
        core.fire(event: Created(item: deposit))
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

        let query = networkAccess.expensesRef().queryOrdered(byChild: Keys.envelopeId).queryEqual(toValue: envelope.id)
        networkAccess.getObject(at: query, core: core) { json in
            var expenses = [Expense]()
            if let json = json {
                expenses = json.compactMap {
                    guard var object = $0.value as? JSONObject else { return nil }
                    object[Keys.id] = $0.key
                    do {
                        return try Expense(object: object)
                    } catch {
                        print(error)
                        return nil
                    }
                }
                expenses.sort { $0.createdAt > $1.createdAt }
                core.fire(event: Loaded(items: expenses))
            } else {
                core.fire(event: Loaded(items: [Expense]()))
            }
        }
    }

}

struct LoadDeposits: Command {

    let networkAccess: FirebaseEnvelopesAccess = FirebaseNetworkAccess.sharedAccess
    let envelope: Envelope

    init(for envelope: Envelope) {
        self.envelope = envelope
    }

    func execute(state: AppState, core: Core<AppState>) {

        let query = networkAccess.depositsRef().queryOrdered(byChild: Keys.envelopeId).queryEqual(toValue: envelope.id)
        networkAccess.getObject(at: query, core: core) { json in
            var deposits = [Deposit]()
            if let json = json {
                deposits = json.compactMap {
                    guard var object = $0.value as? JSONObject else { return nil }
                    object[Keys.id] = $0.key
                    do {
                        return try Deposit(object: object)
                    } catch {
                        print(error)
                        return nil
                    }
                }
                core.fire(event: Loaded(items: deposits))
            } else {
                core.fire(event: Loaded(items: [Deposit]()))
            }
        }
    }

}

struct UpdateGoal: Command {

    var amount: Double
    var isOn: Bool

    init(amount: Double, isOn: Bool) {
        self.amount = amount
        self.isOn = isOn
    }

    func execute(state: AppState, core: Core<AppState>) {
        guard var envelope = state.envelopeState.updatedEnvelope else { return }
        if isOn {
            envelope.goal = amount
        } else {
            envelope.goal = 0
        }
        core.fire(event: Updated(item: envelope))
    }


}
