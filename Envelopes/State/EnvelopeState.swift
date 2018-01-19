//
//  EnvelopeState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct EnvelopeState: State {

    // MARK: - Properties

    var envelopes = [Envelope]()
    var selectedEnvelope: Envelope?
    var newEnvelopeState = NewEnvelopeState()
    var newExpenseState = NewExpenseState()
    var envelopesLoaded = false
    var expensesLoaded = false
    

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
            if let index = envelopes.index(of: event.item) {
                envelopes[index] = event.item
            }
            if selectedEnvelope != nil {
                selectedEnvelope = event.item
            }
        case _ as Loaded<Expense>:
            expensesLoaded = true
        case let event as Created<Expense>:
            if var selectedEnvelope = selectedEnvelope {
                selectedEnvelope.expenses.append(event.item)
                self.selectedEnvelope = selectedEnvelope
                if let index = envelopes.index(of: selectedEnvelope) {
                    envelopes[index] = selectedEnvelope
                }
            }
        case let event as Deleted<Envelope>:
            if let index = envelopes.index(of: event.item) {
                envelopes.remove(at: index)
            }
        case _ as Reset<Envelope>:
            selectedEnvelope = nil
            expensesLoaded = false
        case _ as Reset<NewEnvelope>:
            newExpenseState = NewExpenseState()

        default:
            break
        }

        newEnvelopeState.react(to: event)
        newExpenseState.react(to: event)
    }

}
