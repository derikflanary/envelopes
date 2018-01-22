//
//  MainViewController.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import UIKit
import Reactor
import Firebase

final class MainViewController: UIViewController {

    var core = App.sharedCore
    fileprivate(set) var currentViewController: UIViewController?
    fileprivate var loginViewController = LoginViewController.initializeFromStoryboard()
    fileprivate var homeViewController = HomeViewController.initialViewController()
    fileprivate var loadingViewController = LoadingViewController.initializeFromStoryboard()

    override func viewDidLoad() {
        showLoadingViewController()
        core.add(subscriber: self)
        core.fire(command: CheckAuth())
        
        // TODO: Check if user is still logged in
    }

}


// MARK: - Storyboard initializer

extension MainViewController: StoryboardInitializable {

    static var storyboardName: String { return "Main" }

}



extension MainViewController: Subscriber {

    func update(with state: AppState) {
        DispatchQueue.main.async {
            if Auth.auth().currentUser != nil && !state.loginState.isLoggedIn {
                self.showLoadingViewController()
            } else if !state.loginState.isLoggedIn {
                self.showLoginScreen()
            } else {
                self.showHomeViewController()
            }
        }
    }
}


extension MainViewController {

    func showLoginScreen() {
        _ = showViewController(loginViewController)
    }

    func showHomeViewController() {
        _ = showViewController(homeViewController)
    }

    func showLoadingViewController() {
        _ = showViewController(loadingViewController)
    }


    func showViewController(_ viewController: UIViewController) -> Bool {
        guard currentViewController != viewController else { return false }

        if let controller = currentViewController {
            controller.removeFromParentViewController()
            controller.view.removeFromSuperview()
        }
        addChildViewController(viewController)
        view.addSubview(viewController.view)

        currentViewController = viewController

        return true
    }

}
