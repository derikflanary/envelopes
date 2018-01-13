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
        case frequency
        case goal
        case expenses

        static var allValues: [Row] {
            return [.total, .recurring, .frequency, .goal, .expenses]
        }

    }

    var envelope: Envelope?


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if envelope == nil {
            return 0
        } else {
            return Row.allValues.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row.allValues[indexPath.row] {
        case .total:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TotalCell
            cell.configure(with: envelope)
            return cell
            
        case .recurring:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailsCell
            cell.configure(with: envelope, detailType: .recurring)
            return cell

        case .frequency:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailsCell
            cell.configure(with: envelope, detailType: .frequency)
            return cell

        case .goal:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailsCell
            cell.configure(with: envelope, detailType: .goal)
            return cell
            
        case .expenses:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ExpensesCell
            cell.configure(with: envelope)
            return cell
        }

    }

}
