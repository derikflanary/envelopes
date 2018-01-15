//
//  CashCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/14/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class CashCell: UITableViewCell, ReusableView {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var cashImageView: UIImageView!

    func configure(with envelope: Envelope?) {
        if let quote = quotes.randomElement(), quoteLabel.text == "" {
            quoteLabel.text = "\(quote.text)  - \(quote.author)"
        }
        guard let envelope = envelope else { return }
        switch envelope.totalAmount {
        case 0..<100:
            cashImageView.image = #imageLiteral(resourceName: "envelopeLow")
        case 100..<1000:
            cashImageView.image = #imageLiteral(resourceName: "envelopeHalf")
        default:
            cashImageView.image = #imageLiteral(resourceName: "envelopeFull")
        }
    }
}
