//
//  DetialsCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit


class DetailsCell: UITableViewCell, ReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        subLabel.isHidden = true
    }

    func configure(with envelope: Envelope?, detailType: EnvelopeDetailsDataSource.Row) {
        guard let envelope = envelope else { return }
        titleLabel.text = detailType.displayName
        accessoryType = .none
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
        case .expenses:
            detailLabel.text = envelope.totalExpenses.currency()
            subLabel.isHidden = false
            subLabel.text = String(envelope.expenses.count)
            accessoryType = .disclosureIndicator
        default:
            break
        }
    }

}
