//
//  EnvelopeNameCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

enum CreationType {
    case envelope
    case expense
}

class EnvelopeNameCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    var creationType = CreationType.envelope
    @IBOutlet weak var textField: UITextField!

    func configure(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        textField.text = newEnvelope.name
        creationType = .envelope
    }

    func configure(with newExpense: NewExpense?) {
        guard let newExpense = newExpense else { return }
        textField.text = newExpense.name
        creationType = .expense
    }

    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
        guard textField.text != nil else { return }
        switch creationType {
        case .envelope:
            var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
            newEnvelope.name = textField.text
            core.fire(event: Updated(item: newEnvelope))
        case .expense:
            var newExpense = core.state.envelopeState.newExpenseState.newExpense
            newExpense.name = textField.text
            core.fire(event: Updated(item: newExpense))
        }
    }

}
