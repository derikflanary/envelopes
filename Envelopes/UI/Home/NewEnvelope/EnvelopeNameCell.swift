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
    case deposit
}

class EnvelopeNameCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    var creationType = CreationType.envelope
    private var textCountLimit = 20
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        countLabel.text = String(textCountLimit)
        countLabel.isHidden = true
    }

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

    func configure(with expense: Expense?) {
        guard let expense = expense else { return }
        textField.text = expense.name
        creationType = .expense
    }

    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
        countLabel.isHidden = true
        guard textField.text != nil else { return }
        switch creationType {
        case .envelope:
            var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
            newEnvelope.name = textField.text
            core.fire(event: Updated(item: newEnvelope))
        case .expense:
            switch core.state.envelopeState.expensesState.expenseState {
            case .new:
                var newExpense = core.state.envelopeState.expensesState.newExpense
                newExpense.name = textField.text
                core.fire(event: Updated(item: newExpense))
            case .editing:
                guard var expense = core.state.envelopeState.expensesState.editingExpense, let text = textField.text else { return }
                expense.name = text
                core.fire(event: EditedExpense(expense: expense))
            }
        case .deposit:
            break
        }
    }
    @IBAction func textFieldEditingDidBegin(_ sender: Any) {
        countLabel.isHidden = false
    }

    @IBAction func textFieldEditingChanged(_ sender: Any) {
        guard var text = textField.text else { return }
        if text.count > textCountLimit {
            text = String(text.dropLast())
            textField.text = text
        }
        countLabel.text = String(textCountLimit - text.count)
    }
}
