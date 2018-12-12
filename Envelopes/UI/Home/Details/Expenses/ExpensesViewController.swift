//
//  ExpensesViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class ExpensesViewController: UIViewController, SegueHandlerType {

    // MARK: - Enums

    enum SegueIdentifier: String {
        case presentEdit
    }

    var core = App.sharedCore

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    @IBOutlet var expensesDataSource: ExpensesDataSource!
    @IBOutlet weak var newExpenseButton: RoundedButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyStateView: UIView!


    override func viewDidLoad() {
        newExpenseButton.roundedEdgeType = .full
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = UIColor.darkMain
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newExpenseButton.isShadowed = true
        core.add(subscriber: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }


    // MARK: - Refresh handling

    @objc func handleRefresh() {
        guard let envelope = core.state.envelopeState.selectedEnvelope else { return }
        core.fire(command: LoadExpenses(for: envelope))
        refreshControl.endRefreshing()
    }

}

extension ExpensesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expense = expensesDataSource.expenses[indexPath.row]
        core.fire(event: Selected(item: expense))
        core.fire(event: Selected(item: ExpenseState.editing))
        performSegueWithIdentifier(.presentEdit)
    }
    
}

extension ExpensesViewController: Subscriber {

    func update(with state: AppState) {
        guard let envelope = state.envelopeState.selectedEnvelope else { return }
        expensesDataSource.expenses = envelope.expenses
        if envelope.expenses.isEmpty {
            tableView.backgroundView = emptyStateView
        } else {
            tableView.backgroundView = nil
        }
        tableView.reloadSections([0], with: .automatic)
    }

}
