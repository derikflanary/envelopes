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
        if let selectedEnvelope = core.state.envelopeState.selectedEnvelope {
            envelopeDetailsDataSource.envelope = selectedEnvelope
            tableView.reloadData()
            core.fire(command: LoadExpenses(for: selectedEnvelope))
        }

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

}

extension EnvelopeDetailsViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard var envelope = core.state.envelopeState.selectedEnvelope, let text = titleTextField.text else { return }
        envelope.name = text
        core.fire(event: Updated(item: envelope))
    }

}

extension EnvelopeDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch EnvelopeDetailsDataSource.Row.allValues[indexPath.row] {
        case .expenses:
            performSegue(withIdentifier: "showExpenses", sender: self)
        default:
            break
        }
    }

}

extension EnvelopeDetailsViewController: Subscriber {

    func update(with state: AppState) {
        guard let envelope = state.envelopeState.selectedEnvelope else { return }
        titleTextField.text = envelope.name
        envelopeDetailsDataSource.envelope = envelope
        tableView.reloadData()
    }

}
