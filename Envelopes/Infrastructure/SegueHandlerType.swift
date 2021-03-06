//
//  SegueHandlerType.swift
//  Envelopes
//
//  Created by Derik Flanary on 9/5/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject? = nil) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }

    func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid segue identifier \(String(describing: segue.identifier)).") }
        return segueIdentifier
    }
}
