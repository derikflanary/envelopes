//
//  StartingAmountCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class StartingAmountCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    @IBOutlet weak var textField: UITextField!

    
    func configue(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        let amountText = newEnvelope.startingAmount.currency()
        textField.text = amountText
    }

    @IBAction func textFieldDidBeginEditing(_ sender: Any) {
        textField.text = nil
    }

    @IBAction func textFieldDidEndEditing(_ sender: Any) {
        guard let text = textField.text else { return }
        textField.text = text.currency()
        var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        if let amount = Double(text) {
            newEnvelope.startingAmount = amount
            core.fire(event: Updated(item: newEnvelope))
        }
    }
    
}
