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
        case startingAmount
        case frequency
        case goal

        static var allValues: [Row] {
            return [.name, .amount, .startingAmount, .frequency, .goal]
        }

    }

    var newEnvelope: NewEnvelope?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allValues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row.allValues[indexPath.row] {
        case .name:
            let cell = tableView.dequeueReusableCell(for: indexPath) as EnvelopeNameCell
            cell.configure(with: newEnvelope)
            return cell
        case .amount:
            let cell = tableView.dequeueReusableCell(for: indexPath) as AmountCell
            cell.configue(with: newEnvelope)
            return cell
        case .startingAmount:
            let cell = tableView.dequeueReusableCell(for: indexPath) as StartingAmountCell
            cell.configue(with: newEnvelope)
            return cell
        case .frequency:
            let cell = tableView.dequeueReusableCell(for: indexPath) as FrequencyCell
            cell.configure(with: newEnvelope)
            return cell
        case .goal:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GoalCell
            cell.configue(with: newEnvelope)
            return cell
        }
    }
    
}
