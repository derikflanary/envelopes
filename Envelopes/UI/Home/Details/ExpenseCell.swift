//
//  ExpenseCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell, ReusableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configure(with expense: Expense) {
        nameLabel.text = expense.name
        expenseLabel.text = expense.amount.currency()
        dateLabel.text = expense.createdAt.dayMonthYearString
    }

}
