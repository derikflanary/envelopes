//
//  AmountCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class AmountCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    var creationType = CreationType.envelope
    @IBOutlet weak var textField: UITextField!


    func configue(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        let amountText = newEnvelope.recurringAmount.currency()
        creationType = .envelope
        if newEnvelope.recurringAmount <= 0 {
            textField.placeholder = amountText
        } else {
            textField.text = amountText
        }
    }

    func configure(with newExpense: NewExpense?) {
        guard let newExpense = newExpense else { return }
        
        if let amount = newExpense.amount {
            if amount <= 0 {
                textField.placeholder = amount.currency()
            } else {
                textField.text = amount.currency()
            }
        }
        creationType = .expense
    }

    func configure(with newDeposit: NewDeposit?) {
        guard let deposit = newDeposit else { return }

        if let amount = deposit.amount {
            if amount <= 0 {
                textField.placeholder = amount.currency()
            } else {
                textField.text = amount.currency()
            }
        }
        creationType = .deposit
    }

    @IBAction func textFieldEditingDidBegin(_ sender: Any) {
        textField.text = nil
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
        guard let text = textField.text else { return }
        textField.text = text.currency()
        switch creationType {
        case .envelope:
            let amount = Double(text)
            var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
            if let amount = amount {
                newEnvelope.recurringAmount = amount
                core.fire(event: Updated(item: newEnvelope))
            }
        case .expense:
            let amount = Double(text)
            var newExpense = core.state.envelopeState.newExpenseState.newExpense
            newExpense.amount = amount
            core.fire(event: Updated(item: newExpense))
        case .deposit:
            let amount = Double(text)
            var newDeposit = core.state.envelopeState.newDepositState.newDeposit
            newDeposit.amount = amount
            core.fire(event: Updated(item: newDeposit))
        }
    }
    
}
