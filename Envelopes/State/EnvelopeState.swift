//
//  EnvelopeState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

enum DetailsViewState {
    case viewing
    case editing
}

struct EnvelopeState: State {

    // MARK: - Properties

    var envelopes = [Envelope]()
    var selectedEnvelope: Envelope? {
        didSet {
            updatedEnvelope = selectedEnvelope
        }
    }
    var updatedEnvelope: Envelope?
    var newEnvelopeState = NewEnvelopeState()
    var newExpenseState = NewExpenseState()
    var newDepositState = NewDepositState()
    var envelopesLoaded = false
    var expensesLoaded = false
    var detailsViewState: DetailsViewState = .viewing
    

    // MARK: - React function

    mutating func react(to event: Event) {
        switch event {
        case let event as Loaded<Envelope>:
            self.envelopes = event.items
            envelopesLoaded = true
        case let event as Selected<Envelope>:
            selectedEnvelope = event.item
            if let envelope = selectedEnvelope, envelope.expenses.count > 0 {
                envelopesLoaded = true
            }
        case let event as Created<Envelope>:
            envelopes.append(event.item)
        case let event as Updated<Envelope>:
            switch detailsViewState {
            case .viewing:
                if let index = envelopes.index(of: event.item) {
                    envelopes[index] = event.item
                }
                if selectedEnvelope != nil {
                    selectedEnvelope = event.item
                }
            case .editing:
                updatedEnvelope = event.item
            }
        case let event as Loaded<Expense>:
            expensesLoaded = true
            selectedEnvelope?.expenses = event.items
        case let event as Created<Expense>:
            if var selectedEnvelope = selectedEnvelope {
                selectedEnvelope.expenses.append(event.item)
                self.selectedEnvelope = selectedEnvelope
                if let index = envelopes.index(of: selectedEnvelope) {
                    envelopes[index] = selectedEnvelope
                }
            }
        case let event as Created<Deposit>:
            if var selectedEnvelope = selectedEnvelope {
                selectedEnvelope.deposits.append(event.item)
                self.selectedEnvelope = selectedEnvelope
                if let index = envelopes.index(of: selectedEnvelope) {
                    envelopes[index] = selectedEnvelope
                }
            }
        case let event as Loaded<Deposit>:
            selectedEnvelope?.deposits = event.items
        case let event as Deleted<Envelope>:
            if let index = envelopes.index(of: event.item) {
                envelopes.remove(at: index)
            }
        case let event as Selected<DetailsViewState>:
            detailsViewState = event.item
        case let event as UpdatedEnvelopeTotal:
            guard var envelope = updatedEnvelope else { break }
            envelope.updateAmounts(with: event.newTotal)
            updatedEnvelope = envelope
        case _ as Reset<Envelope>:
            selectedEnvelope = nil
            expensesLoaded = false
        case _ as Reset<NewEnvelope>:
            newEnvelopeState = NewEnvelopeState()
        case _ as Reset<NewExpense>:
            newExpenseState = NewExpenseState()
        case _ as Reset<NewDeposit>:
            newDepositState = NewDepositState()

        default:
            break
        }

        newEnvelopeState.react(to: event)
        newExpenseState.react(to: event)
        newDepositState.react(to: event)
    }

}
