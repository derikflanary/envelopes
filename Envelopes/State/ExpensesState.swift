//
//  NewExpenseState.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Reactor

enum ExpenseState {
    case editing
    case new

    func title() -> String {
        switch self {
        case .editing:
            return "Edit Expense"
        case .new:
            return "New Expense"
        }
    }
}

struct ExpensesState: State {

    // MARK: - Properties

    var newExpense = NewExpense()
    var editingExpense: Expense?
    var expenseState: ExpenseState {
        if editingExpense != nil {
            return .editing
        } else {
            return .new
        }
    }

    // MARK: - React function

    mutating func react(to event: Event) {
        switch event {
        case let event as Updated<NewExpense>:
            newExpense = event.item
        case let event as Selected<Expense>:
            editingExpense = event.item
        case let event as EditedExpense:
            editingExpense = event.expense
        default:
            break
        }

    }

}
