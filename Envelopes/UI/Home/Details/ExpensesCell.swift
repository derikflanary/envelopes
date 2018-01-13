//
//  ExpensesCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class ExpensesCell: UITableViewCell, ReusableView {

    @IBOutlet weak var countLabel: UILabel!

    func configure(with envelope: Envelope?) {
        guard let envelope = envelope else { return }
        countLabel.text = String(envelope.expenses.count)
    }

}
