//
//  DepositCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/21/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class DepositCell: UITableViewCell, ReusableView {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    func configure(with deposit: Deposit) {
        amountLabel.text = deposit.amount.currency()
        dateLabel.text = deposit.createdAt.dayMonthYearString
    }

}
