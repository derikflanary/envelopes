//
//  DepositsDataSource.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/21/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit
import Reactor

class DepositsDataSource: NSObject, UITableViewDataSource {

    var deposits = [Deposit]()
    var core = App.sharedCore

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deposits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as DepositCell
        cell.configure(with: deposits[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let deposit = deposits[indexPath.row]
        core.fire(command: DeleteDeposit(deposit: deposit))
    }

}

