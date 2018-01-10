//
//  FirstNameTextFieldCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit

class FirstNameTextFieldCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBAction func textFieldEditingEnded() {
        guard let text = firstNameTextField.text else { return }
        core.fire(event: FirstNameUpdated(firstName: text))
    }
    
}
