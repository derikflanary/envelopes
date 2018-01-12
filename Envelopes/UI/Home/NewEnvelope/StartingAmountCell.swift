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
        let amountText = String(newEnvelope.startingAmount).dollarAmount()
        textField.text = amountText
    }

    @IBAction func textFieldDidBeginEditing(_ sender: Any) {
        textField.text = nil
    }

    @IBAction func textFieldDidEndEditing(_ sender: Any) {
        guard var text = textField.text else { return }
        let amount = Int(text)
        textField.text = text.dollarAmount()
        var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        if let amount = amount {
            newEnvelope.startingAmount = amount
            core.fire(event: Updated(item: newEnvelope))
        }
    }
    
}
