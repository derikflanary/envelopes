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
        textField.text = amountText
        creationType = .envelope
    }

    func configure(with newExpense: NewExpense?) {
        guard let newExpense = newExpense else { return }
        if let amount = newExpense.amount {
            textField.text = amount.currency()
        }
        creationType = .expense
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
        }
    }
    
}
