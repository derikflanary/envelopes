//
//  QuestionCell.swift
//  foos
//
//  Created by Derik Flanary on 1/16/17.
//  Copyright © 2017 Derik Flanary. All rights reserved.
//

import UIKit
import Reactor

class QuestionCell: UITableViewCell, ReusableView {
    
    var authViewState: AuthViewState?
    var core = App.sharedCore
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
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
        questionLabel.text = authViewState.question()
        actionButton.setTitle(authViewState.questionButtonTitle(), for: .normal)
    }
    
    @IBAction func questionActionButtonTapped() {
        guard let authViewState = authViewState else { return }
        switch authViewState {
        case .main, .register:
            core.fire(event: Updated(item: AuthViewState.signIn))
        case .signIn:
            core.fire(event: Updated(item: AuthViewState.register))
        case .forgotPassword:
            core.fire(event: Updated(item: AuthViewState.signIn))
        }
    }

}

extension QuestionCell: Subscriber {
    
    func update(with state: AppState) {
        authViewState = state.loginState.authViewState
        configure()
    }
    
}
