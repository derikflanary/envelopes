//
//  LoginState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

struct LoginState: State {

    // MARK: - Properties
    
    var isLoggedIn: Bool = false
    var registeringUser: ResgisteringUser = ResgisteringUser()
    var authViewState: AuthViewState = .main
    var user: AuthUser?
    var errorMessage: String?
    var invalidPassword = false


    mutating func react(to event: Event) {
        errorMessage = nil
        invalidPassword = false
        switch event {
        case let event as UserSignedUp:
            isLoggedIn = true
            user = AuthUser(id: event.userId, email: event.email, firstName: nil, lastName: nil)
        case let event as UserLoggedIn:
            isLoggedIn = true
            user = AuthUser(id: event.userId, email: event.email, firstName: nil, lastName: nil)
        case let event as LoggedIn:
            user = event.user
        case let event as UserIdentified:
            isLoggedIn = true
            user = AuthUser(id: event.userId, email: nil, firstName: nil, lastName: nil)
        case let event as Updated<AuthViewState>:
            authViewState = event.item
        case let event as EmailUpdated:
            registeringUser.email = event.email
        case let event as FirstNameUpdated:
            registeringUser.firstName = event.firstName
        case let event as LastNameUpdated:
            registeringUser.lastName = event.lastName
        case let event as PasswordUpdated:
            registeringUser.password = event.password
        case let event as UserAuthFailed:
            errorMessage = event.error.localizedDescription
            guard let code = event.code else { break }
            switch code {
            case .wrongPassword:
                invalidPassword = true
            default:
                break
            }
        default:
            break
        }
    }

}

// MARK: - Enums

enum AuthCellType: String {
    case headlineCell
    case subHeadlineCell
    case actionButtonCell
    case emailTextFieldCell
    case firstNameTextFieldCell
    case lastNameTextFieldCell
    case passwordTextFieldCell
    case forgotPasswordButtonCell
    case seperatorCell
    case questionCell
    case disclaimerCell
}

enum AuthViewState {
    case main
    case register
    case signIn
    case forgotPassword

    func views() -> [AuthCellType] {
        switch self {
        case .main:
            return [
                .subHeadlineCell,
                .actionButtonCell,
                .disclaimerCell,
                .seperatorCell,
                .questionCell]
        case .register:
            return [.emailTextFieldCell,
                    .firstNameTextFieldCell,
                    .lastNameTextFieldCell,
                    .passwordTextFieldCell,
                    .actionButtonCell,
                    .seperatorCell,
                    .questionCell]
        case .signIn:
            return [.emailTextFieldCell,
                    .passwordTextFieldCell,
                    .actionButtonCell,
                    .forgotPasswordButtonCell,
                    .seperatorCell,
                    .questionCell]
        case .forgotPassword:
            return [.subHeadlineCell,
                    .emailTextFieldCell,
                    .actionButtonCell,
                    .seperatorCell,
                    .questionCell ]
        }
    }

    func subHeadline() -> String {
        switch self {
        case .main:
            return "Use the power of envelopes to help you empower your budget."
        case .forgotPassword:
            return "Enter your email and we will send you a link to reset your password."
        default:
            return ""
        }
    }

    func question() -> String {
        switch self {
        case .main, .register:
            return "Already have an account?"
        case .signIn:
            return "No account yet?"
        case .forgotPassword:
            return "Remember now?"
        }
    }

    func actionButtonTitle() -> String {
        switch self {
        case .main, .register:
            return "Sign Up"
        case .signIn:
            return "Log In"
        case .forgotPassword:
            return "Reset Password"
        }
    }

    func questionButtonTitle() -> String {
        switch self {
        case .main, .register, .forgotPassword:
            return "Log in here"
        case .signIn:
            return "Sign up now"
        }
    }
}
