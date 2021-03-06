//
//  TotalCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class TotalCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    
    @IBOutlet weak var totalTextField: UITextField!
    
    func configure(with envelope: Envelope?, isEditing: Bool) {
        guard let envelope = envelope else { return }
        totalTextField.text = envelope.totalAmount.currency()
        if envelope.totalAmount < 0 {
            totalTextField.textColor = UIColor.destructiveRed
        } else {
            totalTextField.textColor = UIColor.grayTwo
        }
    }

    @IBAction func textFieldDidBeginEditing(_ sender: Any) {
        guard let text = totalTextField.text else { return }
        totalTextField.text = String(text.dropFirst())
    }

    @IBAction func textFieldDidEndEditing(_ sender: Any) {
        guard let text = totalTextField.text else {
            totalTextField.text = core.state.envelopeState.selectedEnvelope?.totalAmount.currency()
            return
        }

        if let amount = Double(text) {
            totalTextField.text = text.currency()
            core.fire(event: UpdatedEnvelopeTotal(newTotal: amount))
        }
    }
}
