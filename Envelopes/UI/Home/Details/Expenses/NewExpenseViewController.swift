//
//  NewExpenseViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/12/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class NewExpenseViewController: UIViewController {

    // MARK: - Properties

    var core = App.sharedCore
    private var cancelButtonAnimator = UIViewPropertyAnimator()
    var tapGestureRecognizer = UITapGestureRecognizer()

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var newExpenseDataSource: NewExpenseDataSource!
    

    // MARK: - View life cycle

    override func viewDidLoad() {
        cancelButton.roundedEdgeType = .full
        cancelButton.isShadowed = true
        cancelButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
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
        core.fire(event: Reset<NewExpense>())
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
        let newExpense = core.state.envelopeState.newExpenseState.newExpense
        if newExpense.isReady {
            core.fire(command: AddExpense())
            dismiss()
        } else {
            disableSaveButton()
        }
    }

    @objc func viewTapped() {
        view.endEditing(true)
    }

}

private extension NewExpenseViewController {

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

}


extension NewExpenseViewController: Subscriber {

    func update(with state: AppState) {
        newExpenseDataSource.newExpense = state.envelopeState.newExpenseState.newExpense
        tableView.reloadData()

        if state.envelopeState.newExpenseState.newExpense.isReady {
            enableSaveButton()
        } else {
            disableSaveButton()
        }
    }

}
