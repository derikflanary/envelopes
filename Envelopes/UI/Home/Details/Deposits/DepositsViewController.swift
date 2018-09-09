//
//  ExpensesViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class DepositsViewController: UIViewController {

    var core = App.sharedCore

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet weak var newDepositButton: RoundedButton!
    @IBOutlet var depositsDataSource: DepositsDataSource!


    override func viewDidLoad() {
        newDepositButton.roundedEdgeType = .full
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newDepositButton.isShadowed = true
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

}

extension DepositsViewController: Subscriber {

    func update(with state: AppState) {
        guard let envelope = state.envelopeState.selectedEnvelope else { return }
        depositsDataSource.deposits = envelope.deposits
        if envelope.deposits.isEmpty {
            tableView.backgroundView = emptyStateView
        } else {
            tableView.backgroundView = nil
        }
        tableView.reloadSections([0], with: .automatic)
    }

}

