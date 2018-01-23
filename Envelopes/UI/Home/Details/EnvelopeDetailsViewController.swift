//
//  EnvelopeDetailsViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class EnvelopeDetailsViewController: UIViewController {

    var core = App.sharedCore
    var titleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var envelopeDetailsDataSource: EnvelopeDetailsDataSource!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.font = UIFont.systemFont(ofSize: 21, weight: .light)
        titleTextField.textAlignment = .center
        titleTextField.delegate = self
        navigationItem.titleView = titleTextField
        navigationItem.largeTitleDisplayMode = .never
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        envelopeDetailsDataSource.envelope = core.state.envelopeState.selectedEnvelope
        tableView.reloadData()
        navigationItem.rightBarButtonItem = editButtonItem

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

    @objc func viewTapped() {
        view.endEditing(true)
        titleTextField.resignFirstResponder()
    }

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        switch core.state.envelopeState.detailsViewState {
        case .viewing:
            core.fire(event: Selected(item: DetailsViewState.editing))
        case .editing:
            core.fire(event: Selected(item: DetailsViewState.viewing))
            core.fire(command: EditEnvelope())
        }
    }

}

extension EnvelopeDetailsViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var envelope = core.state.envelopeState.updatedEnvelope, let text = titleTextField.text else { return }
        envelope.name = text
        core.fire(event: Updated(item: envelope))
    }

}

extension EnvelopeDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch envelopeDetailsDataSource.row(for: indexPath) {
        case .expenses:
            performSegue(withIdentifier: "showExpenses", sender: self)
        case .deposits:
            performSegue(withIdentifier: "showDeposits", sender: self)
        case .delete:
            showDeleteActionSheet()
        default:
            break
        }
    }

}

private extension EnvelopeDetailsViewController {

    func showDeleteActionSheet() {
        let actionSheet = UIAlertController(title: "Delete Envelope", message: "Are you sure you want to delete this envelope?", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.core.fire(command: DeleteEnvelope())
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension EnvelopeDetailsViewController: Subscriber {

    func update(with state: AppState) {
        if state.envelopeState.expensesLoaded {
            activityIndicator.stopAnimating()
        }
        guard let envelope = state.envelopeState.selectedEnvelope else { return }
        titleTextField.text = envelope.name
        switch state.envelopeState.detailsViewState {
        case .viewing:
            envelopeDetailsDataSource.isEditing = false
            envelopeDetailsDataSource.envelope = envelope
            navigationItem.rightBarButtonItem?.title = "Edit"
            titleTextField.isUserInteractionEnabled = false
            titleTextField.borderStyle = .none
        case .editing:
            if let updatedEnvelope = state.envelopeState.updatedEnvelope {
                envelopeDetailsDataSource.envelope = updatedEnvelope
            }
            envelopeDetailsDataSource.isEditing = true
            navigationItem.rightBarButtonItem?.title = "Save"
            titleTextField.isUserInteractionEnabled = true
            titleTextField.borderStyle = .roundedRect
        }
        envelopeDetailsDataSource.isLoading = !state.envelopeState.expensesLoaded
        tableView.reloadData()
    }

}
