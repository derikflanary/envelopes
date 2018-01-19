//
//  ActionButtonCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit
import Reactor

class ActionButtonCell: UITableViewCell, ReusableView {

    var core = App.sharedCore
    var authViewState: AuthViewState?
    
    @IBOutlet weak var actionButton: RoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        core.add(subscriber: self)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        core.remove(subscriber: self)
    }
    
    func configure() {
        guard let authViewState = authViewState else { return }
        actionButton.setTitle(authViewState.actionButtonTitle(), for: .normal)
    }
    
    @IBAction func actionButtonTapped() {
        guard let authViewState = authViewState else { return }
        switch authViewState {
        case .main:
            core.fire(event: Updated(item: AuthViewState.register))
        case .signIn:
            core.fire(command: Login())
        case .register:
            core.fire(command: SignUpNewUser())
        case .forgotPassword:
            core.fire(command: ForgotPassword())
        }
    }
    
}

extension ActionButtonCell: Subscriber {
    
    func update(with state: AppState) {
        authViewState = state.loginState.authViewState
        let registeringUser = state.loginState.registeringUser
        configure()
        switch state.loginState.authViewState {
        case .main:
            actionButton.isEnabled = true
        case .register:
            actionButton.isEnabled = registeringUser.isRegistrationComplete
        case .signIn:
            actionButton.isEnabled = registeringUser.isSignInComplete
        case.forgotPassword:
            actionButton.isEnabled = registeringUser.isValidEmail
        }
    }
    
}
