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

    var id: String
    var createdAt = Date()
    var modifiedAt = Date()
    var isActive: Bool = true
    var name: String = "Name"
    var ownerId: String = "1"
    var periodicity: Periodicity = .monthly
    var recurringAmount: Double = 10
    var totalAmount: Double = 0
    var goal: Double = 0
    var expenses = [Expense]()

    init(id: String) {
        self.id = id
    }
}

extension Envelope: JSONMarshaling {

    func jsonObject() -> JSONObject {
        return [:]
    }

}

extension Envelope: Equatable {

    static func ==(lhs: Envelope, rhs: Envelope) -> Bool {
        return lhs.id == rhs.id
    }

}
