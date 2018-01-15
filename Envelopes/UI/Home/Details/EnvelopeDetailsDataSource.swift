//
//  EnvelopeDetailsDataSource.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

class EnvelopeDetailsDataSource: NSObject, UITableViewDataSource {

    enum Row {
        case total
        case recurring
        case accumulated
        case frequency
        case goal
        case expenses
        case date
        case image

        static var allValues: [Row] {
            return [.recurring, .frequency, .accumulated, .expenses, .total, .goal, .date, .image]
        }

        static var allValuesNoGoal: [Row] {
            return [.recurring, .frequency, .accumulated, .expenses, .total, .date, .image]
        }


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
            case .total:
                return "Total"
            case .expenses:
                return "Expenses"
            case .date:
                return "Started On"
            case .image:
                return ""
            }
        }

    }

    var envelope: Envelope?


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let envelope = envelope {
            if envelope.hasGoal {
                return Row.allValues.count
            } else {
                return Row.allValuesNoGoal.count
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var row: Row
        if envelope!.hasGoal {
            row = Row.allValues[indexPath.row]
        } else {
            row = Row.allValuesNoGoal[indexPath.row]
        }
        switch row {
        case .total:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TotalCell
            cell.configure(with: envelope)
            return cell
            
        case .recurring, .frequency, .accumulated, .goal, .expenses, .date:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailsCell
            cell.configure(with: envelope, detailType: row)
            return cell

        case .image:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CashCell
            cell.configure(with: envelope)
            return cell
        }

    }

}
