//
//  Envelope.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

enum Periodicity {
    case daily
    case weekly(Weekday)
    case monthly
}

struct Envelope {

    var createdAt = Date()
    var modifiedAt = Date()
    var isActive: Bool
    var name: String
    var ownerId: String
    var periodicity: Periodicity
    var recurringAmount: Double
    var totalAmount: Double
    var expences = [Expense]()

}

extension Envelope: JSONMarshaling {

    func jsonObject() -> JSONObject {
        return [:]
    }

}
