//
//  ExpensesViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class ExpensesViewController: UIViewController {

    var core = App.sharedCore
    
    @IBOutlet var expensesDataSource: ExpensesDataSource!
    @IBOutlet weak var newExpenseButton: RoundedButton!
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        newExpenseButton.roundedEdgeType = .full
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

}

extension ExpensesViewController: Subscriber {

    func update(with state: AppState) {
        guard let envelope = state.envelopeState.selectedEnvelope else { return }
        expensesDataSource.expenses = envelope.expenses
        tableView.reloadData()
    }

}
