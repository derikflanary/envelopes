//
//  TotalCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class TotalCell: UITableViewCell, ReusableView {

    @IBOutlet weak var label: UILabel!

    func configure(with envelope: Envelope?) {
        guard let envelope = envelope else { return }
        label.text = String(envelope.totalAmount).dollarAmount()
    }

}
