//
//  HomeViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor

final class HomeViewController: UIViewController, StoryboardInitializable {

    // MARK: Properties

    static var storyboardName = "Home"
    static var viewControllerIdentifier = "HomeNav"

    static func initialViewController() -> UINavigationController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? UINavigationController else { fatalError("Error instantiating initial view controller from storyboard \(storyboardName)") }
        return vc
    }

    var core = App.sharedCore

    @IBOutlet weak var newButton: RoundedButton!


    // MARK: View life cycle

    override func viewDidLoad() {
        newButton.roundedEdgeType = .full
        navigationController?.navigationBar.prefersLargeTitles = true
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

extension HomeViewController: Subscriber {

    func update(with state: AppState) {

    }
}
