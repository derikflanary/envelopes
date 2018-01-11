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

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var popView: UIView!


    // MARK: - View life cycle

    override func viewDidLoad() {
        cancelButton.roundedEdgeType = .full
        cancelButton.isShadowed = true
        cancelButton.transform = CGAffineTransform(scaleX: 0, y: 0)
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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popView.layer.cornerRadius = 10
        popView.clipsToBounds = true
    }


    // MARK: - Button actions

    @IBAction func cancelButtonTapped() {
        dismiss()
    }

    @IBAction func saveButtonTapped() {
        dismiss()
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

}

extension NewEnvelopeViewController: Subscriber {

    func update(with state: AppState) {

    }

}
