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
    @IBOutlet weak var textField: UITextField!


    func configue(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        let amountText = String(newEnvelope.recurringAmount).dollarAmount()
        textField.text = amountText
    }

    @IBAction func textFieldEditingDidBegin(_ sender: Any) {
        textField.text = nil
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
        guard let text = textField.text else { return }
        textField.text = text.dollarAmount()
        let amount = Int(text)
        var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        if let amount = amount {
            newEnvelope.recurringAmount = amount
            core.fire(event: Updated(item: newEnvelope))
        }
    }
    
}
