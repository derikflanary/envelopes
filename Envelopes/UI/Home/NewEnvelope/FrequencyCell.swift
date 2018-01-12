//
//  FrequencyCell.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class FrequencyCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var frequencyButton: UIButton!
    @IBOutlet weak var weekdayButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        weekdayButton.isHidden = true
    }

    func configure(with newEnvelope: NewEnvelope?) {
        guard let newEnvelope = newEnvelope else { return }
        frequencyButton.setTitle(newEnvelope.periodicity.displayName, for: .normal)
        switch newEnvelope.periodicity {
        case .daily, .monthly:
            weekdayButton.isHidden = true
        case .weekly(let weekday):
            weekdayButton.isHidden = false
            weekdayButton.setTitle(weekday.displayName, for: .normal)
        }
    }

}
