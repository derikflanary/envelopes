//
//  NewEnvelope.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/11/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation

struct NewEnvelope {

    var name: String?
    var recurringAmount: Double = 0
    var startingAmount: Double = 0
    var periodicity: Periodicity = .daily
    var goal: Double = 0

    var isReady: Bool {
        return name != nil
    }
    
}
