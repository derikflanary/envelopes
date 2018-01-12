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
        case details
        case amount
        case frequency
        case goal
        case expenses

        static var allValues: [Row] {
            return [.details, .amount, .frequency, .goal, .expenses]
        }

    }

    var newEnvelope: NewEnvelope?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailsCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as ExpensesCell
            return cell
        }
    }

}
