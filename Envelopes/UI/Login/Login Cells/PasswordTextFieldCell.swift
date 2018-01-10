//
//  PasswordTextFieldCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit

class PasswordTextFieldCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func textFieldEditingEnded() {
        guard let text = passwordTextField.text else { return }
        guard text.characters.count > 5 else { return }
        core.fire(event: PasswordUpdated(password: text))
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        guard let text = passwordTextField.text else { return }
        guard text.characters.count > 5 else { return }
        core.fire(event: PasswordUpdated(password: text))
    }
}


