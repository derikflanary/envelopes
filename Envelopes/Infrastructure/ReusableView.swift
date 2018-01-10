//
//  ReusableView.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
        let identifier = String(describing: self)
        return identifier
    }

}
