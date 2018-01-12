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

    var displayName: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly(_):
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }
}

struct Envelope {

    var id: String = Date().iso8601String
    var createdAt = Date()
    var modifiedAt = Date()
    var isActive: Bool = true
    var ownerId: String
    var name: String
    var periodicity: Periodicity = .monthly
    var recurringAmount: Int
    var totalAmount: Int = 0
    var goal: Int = 0
    var expenses = [Expense]()

    init(newEnvelope: NewEnvelope) {
        ownerId = "user"
        name = newEnvelope.name!
        periodicity = newEnvelope.periodicity
        recurringAmount = newEnvelope.recurringAmount
        goal = newEnvelope.goal
        totalAmount = newEnvelope.startingAmount
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
