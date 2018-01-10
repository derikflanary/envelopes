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

    var core = App.sharedCore


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }

}

extension NewEnvelopeViewController: Subscriber {

    func update(with state: AppState) {

    }

}
