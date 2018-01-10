//
//  EmailTextFieldCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit
import Reactor

class EmailTextFieldCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        core.add(subscriber: self)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        core.remove(subscriber: self)
    }
    
    @IBAction func textFieldEditingEnded() {
        guard let text = emailTextField.text else { return }
        core.fire(event: EmailUpdated(email: text))
    }
}


extension EmailTextFieldCell: Subscriber {
    
    func update(with state: AppState) {
        if !state.loginState.registeringUser.isValidEmail && emailTextField.text != "" {
            errorLabelHeightConstraint.constant = 12
            UIView.animate(withDuration: 0.5, animations: { 
                self.errorLabel.alpha = 1.0
                self.layoutIfNeeded()
            })
        } else {
            errorLabelHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.errorLabel.alpha = 0.0
                self.layoutIfNeeded()
            })
        }
    }
    
}
