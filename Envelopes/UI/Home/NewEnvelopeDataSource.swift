//
//  NewEnvelopeDataSource.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit

class NewEnvelopeDataSource: NSObject, UITableViewDataSource {

    enum Row {
        case name
        case amount
        case frequency
        case goal

        static var allValues: [Row] {
            return [.name, .amount, .frequency, .goal]
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allValues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row.allValues[indexPath.row] {
        case .name:
            return tableView.dequeueReusableCell(withIdentifier: EnvelopeNameCell.reuseIdentifier, for: indexPath)
        case .amount:
            return tableView.dequeueReusableCell(withIdentifier: AmountCell.reuseIdentifier, for: indexPath)
        case .frequency:
            return tableView.dequeueReusableCell(withIdentifier: FrequencyCell.reuseIdentifier, for: indexPath)
        case .goal:
            return tableView.dequeueReusableCell(withIdentifier: GoalCell.reuseIdentifier, for: indexPath)
        }
    }
    
}
