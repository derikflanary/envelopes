//
//  LastNameTextFieldCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit

class LastNameTextFieldCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBAction func textFieldEnditingEnded() {
        guard let text = lastNameTextField.text else { return }
        core.fire(event: LastNameUpdated(lastName: text))
    }
    
}
