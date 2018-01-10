//
//  StoryboardInitializable.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInitializable {
    static var storyboardName: String { get }
    static func initializeFromStoryboard() -> Self
}

extension StoryboardInitializable where Self: UIViewController {

    static var viewControllerIdentifier: String {
        return String(describing: self)
    }

    static func initializeFromStoryboard() -> Self {
        let bundle = Bundle(for: Self.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let vc = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self else { fatalError("Error instantiating \(self) from storyboard") }
        return vc
    }

    static func initialViewController() -> UIViewController {
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? UINavigationController else { fatalError("Error instantiating initial view controller from storyboard \(storyboardName)") }
        return vc    }

}

