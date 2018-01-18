//
//  NewEnvelopeViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class NewEnvelopeViewController: UIViewController {

    // MARK: - Properties

    var core = App.sharedCore
    private var cancelButtonAnimator = UIViewPropertyAnimator()
    var tapGestureRecognizer = UITapGestureRecognizer()

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet var newEnvelopeDataSource: NewEnvelopeDataSource!
    @IBOutlet weak var tableView: UITableView!
    

    // MARK: - View life cycle

    override func viewDidLoad() {
        cancelButton.roundedEdgeType = .full
        cancelButton.isShadowed = true
        cancelButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        let newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        newEnvelopeDataSource.newEnvelope = newEnvelope
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        core.add(subscriber: self)
        UIView.animate(withDuration: 0.5, animations: {
            self.transparentView.alpha = 0.6
        })
        cancelButtonAnimator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1.0, animations: { })
        cancelButtonAnimator.addAnimations({
            self.cancelButton.transform = CGAffineTransform.identity
        }, delayFactor: 0.5)
        cancelButtonAnimator.startAnimation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
        core.fire(event: Reset<NewEnvelope>())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !popView.clipsToBounds else { return }
        setupPopView()
    }


    // MARK: - Button actions

    @IBAction func cancelButtonTapped() {
        dismiss()
    }

    @IBAction func saveButtonTapped() {
        let newEnvelope = core.state.envelopeState.newEnvelopeState.newEnvelope
        if newEnvelope.isReady {
            core.fire(command: AddEnvelope())
            dismiss()
        } else {
            disableSaveButton()
        }
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }

}

private extension NewEnvelopeViewController {

    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transparentView.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }

    func setupPopView() {
        popView.layer.cornerRadius = 10
        popView.clipsToBounds = true
        popView.layer.shadowOpacity = 0.5
        popView.layer.shadowRadius = 3.0
        popView.layer.shadowOffset = CGSize(width: 0, height: 0)
        popView.layer.shadowColor = UIColor.black.cgColor
        popView.layer.masksToBounds = false
    }

    func disableSaveButton() {
        guard saveButton.alpha != 0.5 else { return }
        saveButton.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.saveButton.alpha = 0.5
        }
    }

    func enableSaveButton() {
        saveButton.isEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.saveButton.alpha = 1.0
        }
    }

    func showFrequencySelectionView() {
        let alertController = UIAlertController(title: "Frequency", message: "Select how often you want to recurringly add funds to your envelope.", preferredStyle: .actionSheet)
        let monthly = UIAlertAction(title: "Monthly", style: .default, handler: { action in
            self.core.fire(event: Selected(item: Periodicity.monthly(Date())))
        })
        let weekly = UIAlertAction(title: "Weekly", style: .default, handler: { action in
            self.showWeekdaySelectionView()
        })
        let daily = UIAlertAction(title: "Daily", style: .default, handler: { action in
            self.core.fire(event: Selected(item: Periodicity.daily))
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(monthly)
        alertController.addAction(weekly)
        alertController.addAction(daily)
        alertController.addAction(cancel)
        show(alertController, sender: self)
    }

    func showWeekdaySelectionView() {
        let alertController = UIAlertController(title: "Frequency", message: "Select how often you want to recurringly add funds to your envelope.", preferredStyle: .actionSheet)
        let sunday = UIAlertAction(title: "Sunday", style: .default, handler: { action in
            self.core.fire(event: Selected(item: Periodicity.weekly(.sunday)))
        })
        let monday = UIAlertAction(title: "Monday", style: .default, handler: { action in
            self.core.fire(event: Selected(item: Periodicity.weekly(.monday)))
        })

        alertController.addAction(sunday)
        alertController.addAction(monday)
        show(alertController, sender: self)
    }

}


extension NewEnvelopeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = NewEnvelopeDataSource.Row.allValues[indexPath.row]
        switch row {
        case .frequency:
            showFrequencySelectionView()
        default:
            break
        }
    }

}

extension NewEnvelopeViewController: Subscriber {

    func update(with state: AppState) {
        let newEnvelope = state.envelopeState.newEnvelopeState.newEnvelope
        newEnvelopeDataSource.newEnvelope = newEnvelope
        tableView.reloadData()

        if newEnvelope.isReady {
            enableSaveButton()
        } else {
            disableSaveButton()
        }
    }

}
