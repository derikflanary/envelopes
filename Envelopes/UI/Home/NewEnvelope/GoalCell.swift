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
    @IBOutlet weak var descriptionLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        disableTextField()
    }

    func configue(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        let amountText = newEnvelope.goal.currency()
        textField.text = amountText
        if newEnvelope.goal > 0 {
            switcher.setOn(true, animated: false)
            enableTextField()
        } else {
            switcher.setOn(false, animated: false)
            disableTextField()
        }
    }

    func configure(with envelope: Envelope?, isEditing: Bool) {
        guard let envelope = envelope else { return }
        let amountText = envelope.goal.currency()
        textField.text = amountText

        if isEditing {
            switcher.isHidden = false
            switcher.isOn = envelope.goal > 0
            textField.borderStyle = .roundedRect
            descriptionLabel.text = Localized.goalDescription
        } else {
            switcher.isHidden = true
            textField.borderStyle = .none
            descriptionLabel.text = nil
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
            updateGoal()
        }
    }

    func updateGoal() {
        guard let text = textField.text else { return }
        if let amount = Double(text.dropFirst()) {
            core.fire(command: UpdateGoal(amount: amount, isOn: switcher.isOn))
        }
    }
    
    @IBAction func textFieldDidBeginEditing(_ sender: Any) {
        textField.text = nil
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: Any) {
        guard let text = textField.text else { return }
        textField.text = text.currency()
        switch core.state.envelopeState.detailsViewState {
        case .viewing:
            var newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
            if let amount = Double(text) {
                newEnvelope.goal = amount
                core.fire(event: Updated(item: newEnvelope))
            }
        case .editing:
            updateGoal()
        }
    }
    
}
