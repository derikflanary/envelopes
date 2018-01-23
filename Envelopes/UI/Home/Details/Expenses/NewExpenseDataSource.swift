//
//  NewExpenseDataSource.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

class NewExpenseDataSource: NSObject, UITableViewDataSource {

    enum Row {
        case name
        case amount

        static var allValues: [Row] {
            return [.name, .amount]
        }

    }

    var newExpense: NewExpense?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allValues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row.allValues[indexPath.row] {
        case .name:
            let cell = tableView.dequeueReusableCell(for: indexPath) as EnvelopeNameCell
            cell.configure(with: newExpense)
            return cell
        case .amount:
            let cell = tableView.dequeueReusableCell(for: indexPath) as AmountCell
            cell.configure(with: newExpense)
            return cell
        }
    }

}
