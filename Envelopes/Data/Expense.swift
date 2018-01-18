//
//  Expense.swift
//  Envelopes
//
//  Created by Derik Flanary on 1/10/18.
//  Copyright © 2018 Dezvolta. All rights reserved.
//

import Foundation
import Marshal

struct Expense: Unmarshaling {

    var id: String = Date().iso8601String
    var createdAt = Date()
    var modifiedAt = Date()
    var amount: Double
    var name: String

    init(object: MarshaledObject) throws {
        let createdAtInt: Int = try object.value(for: Keys.createdAt)
        let createdAt: Date = Date(timeIntervalSince1970: Double(createdAtInt) / 1000)
        self.createdAt = createdAt

        let modifiedAtInt: Int = try object.value(for: Keys.modifiedAt)
        let modifiedAt: Date = Date(timeIntervalSince1970: Double(modifiedAtInt) / 1000)
        self.modifiedAt = modifiedAt
        amount = try object.value(for: Keys.amount)
        name = try object.value(for: Keys.name)
    }

    init(_ newExpense: NewExpense) {
        amount = newExpense.amount!
        name = newExpense.name!
    }
}

extension Expense: JSONMarshaling {

    func jsonObject() -> JSONObject {
        return [Keys.createdAt: createdAt.millisecondsSince1970,
                Keys.modifiedAt: modifiedAt.millisecondsSince1970,
                Keys.amount: amount,
                Keys.name: name]
    }

}

struct NewExpense {

    var amount: Double?
    var name: String?

    var isReady: Bool {
        return amount != nil && name != nil
    }
    
}

// MARK: - Endpoint naming

extension Envelope: EndpointNaming {

    static let endpointName = Keys.Endpoint.envelopes

}
