//
//  NewExpenseDataSource.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

class NewDepositDataSource: NSObject, UITableViewDataSource {

    var newDeposit: NewDeposit?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(for: indexPath) as AmountCell
            cell.configure(with: newDeposit)
            return cell
    }

}

