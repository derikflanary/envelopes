//
//  SettingsViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/21/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor
import Crashlytics

class SettingsViewController: UIViewController {

    var core = App.sharedCore

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        core.add(subscriber: self)
        Crashlytics.sharedInstance().crash()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        core.remove(subscriber: self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func logoutButtonTapped() {
        dismiss(animated: true) {
            self.core.fire(command: LogOut())
        }
    }

}

extension SettingsViewController: Subscriber {

    func update(with state: AppState) {

    }

}

