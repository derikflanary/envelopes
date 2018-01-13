//
//  ExpensesDataSource.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

class ExpensesDataSource: NSObject, UITableViewDataSource {

    var expenses = [Expense]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ExpenseCell
        cell.configure(with: expenses[indexPath.row])
        return cell
    }
    
}
