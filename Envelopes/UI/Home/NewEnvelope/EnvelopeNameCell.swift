//
//  EnvelopeNameCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class EnvelopeNameCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    @IBOutlet weak var textField: UITextField!

    func configure(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        textField.text = newEnvelope.name
    }

    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
        guard textField.text != nil else { return }
        var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        newEnvelope.name = textField.text
        core.fire(event: Updated(item: newEnvelope))
    }

}
