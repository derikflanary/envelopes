//
//  LoginViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor


final class LoginViewController: UIViewController, StoryboardInitializable {

    // MARK: Properties

    static var storyboardName = "Main"
    var core = App.sharedCore

    @IBOutlet var loginTableViewDatasource: LoginDataSource!
    @IBOutlet weak var loginTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
 

    // MARK: View life cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTableView.rowHeight = UITableViewAutomaticDimension
        loginTableView.estimatedRowHeight = 60
    }


    // MARK: Interface actions

    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(true)
    }

}


// MARK: - Private functions

private extension LoginViewController {

    func transition(to newViewState: AuthViewState, from currentViewState: AuthViewState) {
        let diff = currentViewState.views().diff(newViewState.views())
        let addedIndexes: [IndexPath] = diff.addedIndexes.flatMap { IndexPath(row: $0, section: 0) }
        let removedIndexes: [IndexPath] = diff.removedIndexes.flatMap { IndexPath(row: $0, section: 0) }
        loginTableViewDatasource.authViewState = newViewState
        loginTableView.beginUpdates()
        loginTableView.insertRows(at: addedIndexes, with: .fade)
        loginTableView.deleteRows(at: removedIndexes, with: .fade)
        loginTableView.endUpdates()
    }

}


// MARK: Subscriber

extension LoginViewController: Subscriber {
    func update(with state: AppState) {
        switch state.loginState.authViewState {
        case .main:
            titleLabel.text = "Welcome"
        case .register:
            titleLabel.text = "Register"
        case .signIn:
            titleLabel.text = "Sign In"
        case .forgotPassword:
            titleLabel.text = "Reset Password"
        }
        if let previousViewState = loginTableViewDatasource.authViewState {
            transition(to: state.loginState.authViewState, from: previousViewState)
        } else {
            loginTableViewDatasource.authViewState = .main
            loginTableView.reloadData()
        }

    }
}

