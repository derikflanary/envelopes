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


    @IBAction func textFieldEditingDidBegin(_ sender: Any) {
        textField.text = nil
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
        guard var text = textField.text else { return }
        let amount = Int(text)
        text.insert("$", at: text.startIndex)
        textField.text = text
        var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        if let amount = amount {
            newEnvelope.recurringAmount = amount
            core.fire(event: Updated(item: newEnvelope))
        }
    }
}
