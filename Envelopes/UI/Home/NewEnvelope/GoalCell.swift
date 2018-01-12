//
//  GoalCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell, ReusableView {

    var core = App.sharedCore

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var switcher: UISwitch!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        disableTextField()
    }

    func configue(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        var amountText = String(newEnvelope.goal)
        amountText.insert("$", at: amountText.startIndex)
        textField.text = amountText
        if newEnvelope.goal > 0 {
            switcher.setOn(true, animated: false)
            enableTextField()
        } else {
            switcher.setOn(false, animated: false)
            disableTextField()
        }
    }

    func disableTextField() {
        textField.isEnabled = false
        textField.alpha = 0.1
    }

    func enableTextField() {
        textField.isEnabled = true
        textField.alpha = 1.0
    }

    @IBAction func switcherDidChange(_ sender: Any) {
        if switcher.isOn {
            enableTextField()
        } else {
            disableTextField()
        }
    }
    
    @IBAction func textFieldDidBeginEditing(_ sender: Any) {
        textField.text = nil
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: Any) {
        guard var text = textField.text else { return }
        let amount = Int(text)
        text.insert("$", at: text.startIndex)
        textField.text = text
        var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        if let amount = amount {
            newEnvelope.goal = amount
            core.fire(event: Updated(item: newEnvelope))
        }
    }
    
}
