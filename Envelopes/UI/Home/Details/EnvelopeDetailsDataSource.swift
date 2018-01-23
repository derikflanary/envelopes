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

    enum Section {
        case contents
        case details


        static let allValues = [Section.contents, Section.details]

        func title() -> String {
            switch self {
            case .contents:
                return "Contents"
            case .details:
                return "Details"
            }
        }

        func rows(isEditing: Bool, hasGoal: Bool) -> [Row] {
            switch self {
            case .contents:
                return [.startingAmount, .accumulated, .expenses, .deposits, .total]
            case .details:
                if isEditing || hasGoal {
                    return [.goal, .date, .recurring, .frequency, .image]
                } else {
                    return [.date, .recurring, .frequency, .image]
                }
            }
        }

    }

    enum Row {
        case total
        case recurring
        case accumulated
        case frequency
        case goal
        case expenses
        case startingAmount
        case deposits
        case date
        case image

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
            case .deposits:
                return "Deposits"
            case .startingAmount:
                return "Starting Amount"
            case .image:
                return ""
            }
        }

    }

    var envelope: Envelope?
    var isLoading: Bool = true
    var isEditing: Bool = false


    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allValues.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !isLoading else { return 0 }
        guard let envelope = envelope else { return 0}

        let sectionCase = Section.allValues[section]
        return sectionCase.rows(isEditing: isEditing, hasGoal: envelope.hasGoal).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allValues[indexPath.section]
        let row = section.rows(isEditing: isEditing, hasGoal: envelope!.hasGoal)[indexPath.row]

        switch row {
        case .total:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TotalCell
            cell.configure(with: envelope, isEditing: isEditing)
            return cell
            
        case .recurring, .frequency, .accumulated, .expenses, .date, .deposits, .startingAmount:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailsCell
            cell.configure(with: envelope, detailType: row)
            return cell

        case .goal:
            if isEditing {
                let cell = tableView.dequeueReusableCell(for: indexPath) as GoalCell
                cell.configure(with: envelope, isEditing: isEditing)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailsCell
                cell.configure(with: envelope, detailType: row)
                return cell
            }

        case .image:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CashCell
            cell.configure(with: envelope)
            return cell
        }

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allValues[section].title()
    }

    func row(for indexPath: IndexPath) -> Row {
        return EnvelopeDetailsDataSource.Section.allValues[indexPath.section].rows(isEditing: isEditing, hasGoal: envelope!.hasGoal)[indexPath.row]
    }

}
