//
//  EnvelopePeekViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/23/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

class EnvelopePeekViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    var core = App.sharedCore

    override var previewActionItems: [UIPreviewActionItem] {
        return previewActions
    }
    
    lazy var previewActions: [UIPreviewActionItem] = {
        let deleteAction = UIPreviewAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (previewAction, viewController) -> Void in
            self.core.fire(command: DeleteEnvelope())
        })

        return [deleteAction]
    }()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        core.add(subscriber: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }
}

extension EnvelopePeekViewController: Subscriber {

    func update(with state: AppState) {
        if let envelope = state.envelopeState.selectedEnvelope {
            nameLabel.text = envelope.name
            totalLabel.text = envelope.totalAmount.currency()
        }
    }

}
