//
//  ForgotPasswordButtonCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit
import Reactor

class ForgotPasswordButtonCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    
    @IBAction func forgotButtonTapped() {
        core.fire(event: Updated(item: AuthViewState.forgotPassword))
//        core.fire(command: ResetPassword())
    }

}
