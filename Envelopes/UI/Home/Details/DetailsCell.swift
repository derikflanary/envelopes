//
//  DetialsCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

enum DetailCellType {
    case recurring
    case goal
    case frequency
    case accumulated

    var displayName: String {
        switch self {
        case .recurring:
            return "Recurring Amount"
        case .goal:
            return "Savings Goal"
        case .frequency:
            return "Frequency"
        case .accumulated:
            return "Amount Accumulated"
        }
    }
}

class DetailsCell: UITableViewCell, ReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        subLabel.isHidden = true
    }

    func configure(with envelope: Envelope?, detailType: DetailCellType) {
        guard let envelope = envelope else { return }
        titleLabel.text = detailType.displayName
        switch detailType {
        case .recurring:
            detailLabel.text = envelope.recurringAmount.currency()
            subLabel.isHidden = true
        case .goal:
            detailLabel.text = envelope.goal.currency()
            subLabel.isHidden = true
        case .frequency:
            detailLabel.text = envelope.periodicity.displayName
            switch envelope.periodicity {
            case .weekly(let weekday):
                subLabel.isHidden = false
                subLabel.text = weekday.displayName
            default:
                subLabel.isHidden = true
            }
        case .accumulated:
            detailLabel.text = envelope.accumulatedAmount.currency()
            subLabel.isHidden = true
        }
    }

}
