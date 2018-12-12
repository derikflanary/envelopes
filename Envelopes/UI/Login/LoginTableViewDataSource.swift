//
//  LoginTableViewDataSource.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

class LoginDataSource: NSObject, UITableViewDataSource {

    var authCellTypes = [AuthCellType]()
    var authViewState: AuthViewState?
    var passwordError: Bool = false


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let authViewState = authViewState else { return 0 }
        return authViewState.views().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let authViewState = authViewState else { return tableView.dequeueReusableCell(for: indexPath) as SeperatorCell  }
        let cellType = authViewState.views()[indexPath.row]
        switch cellType {
        case .headlineCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as HeadlineCell
            return cell
        case .subHeadlineCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as SubHeadlineCell
            cell.configure(with: authViewState)
            return cell
        case .actionButtonCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ActionButtonCell
            return cell
        case .emailTextFieldCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as EmailTextFieldCell
            return cell
        case .firstNameTextFieldCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as FirstNameTextFieldCell
            return cell
        case .lastNameTextFieldCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as LastNameTextFieldCell
            return cell
        case .passwordTextFieldCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PasswordTextFieldCell
            cell.configure(passwordError: passwordError)
            return cell
        case .forgotPasswordButtonCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ForgotPasswordButtonCell
            return cell
        case .seperatorCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as SeperatorCell
            return cell
        case .questionCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as QuestionCell
            return cell
        case .disclaimerCell:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DisclaimerCell
            return cell
        }
    }

}

